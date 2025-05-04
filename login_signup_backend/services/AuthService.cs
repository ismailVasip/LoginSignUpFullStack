using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Mail;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using AutoMapper;
using login_signup_backend.dtos;
using login_signup_backend.interfaces;
using login_signup_backend.models;
using login_signup_backend.repositories;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace login_signup_backend.services
{
  public class AuthService : IAuthService
  {
    private readonly IMapper _mapper;
    private readonly UserManager<User> _userManager;
    private readonly IConfiguration _configuration;
    private readonly MailSettings _mailSettings;
    private readonly RepositoryContext _context;
    private readonly Random _random = new Random();
    private readonly IMemoryCache _memoryCache;

    private User? _user;

    public AuthService(IMapper mapper, UserManager<User> userManager, IConfiguration configuration, IOptions<MailSettings> mailSettings, RepositoryContext context, IMemoryCache memoryCache)
    {
      _mapper = mapper;
      _userManager = userManager;
      _configuration = configuration;
      _mailSettings = mailSettings.Value;
      _context = context;
      _memoryCache = memoryCache;
    }

    public async Task<TokenDto> CreateTokenAsync(bool populateExp, User user)
    {
      var signinCredentials = GetSignInCredentials();
      var claims = await GetClaims(user);
      var tokenOptions = GenerateTokenOptions(signinCredentials, claims);

      var refreshToken = GenerateRefreshToken();
      user.RefreshToken = refreshToken;

      if (populateExp)
        user.RefreshTokenExpiryTime = DateTime.Now.AddDays(7);

      await _userManager.UpdateAsync(user);

      var accessToken = new JwtSecurityTokenHandler().WriteToken(tokenOptions);

      return new TokenDto
      {
        AccessToken = accessToken,
        RefreshToken = refreshToken
      };
    }

    public async Task<IdentityResult> RegisterUserAsync(UserForRegistrationDto request)
    {
      if (!string.IsNullOrEmpty(request.PhoneNumber))
      {
        var phoneExists = await _userManager.Users
                               .AnyAsync(u => u.PhoneNumber == request.PhoneNumber);
        if (phoneExists)
        {
          return IdentityResult.Failed(new IdentityError
          {
            Code = "DuplicatePhoneNumber",
            Description = "This phone number is already taken."
          });
        }
      }

      var user = _mapper.Map<User>(request);
      if (user == null)
      {
        return IdentityResult.Failed(new IdentityError
        {
          Code = "MappingError",
          Description = "Could not map registration data to user object."
        });
      }

      var result = await _userManager.CreateAsync(user, request.Password);

      if (!result.Succeeded)
      {
        var filteredErrors = result.Errors
       .Where(error => !error.Code.Contains("UserName") &&
                      !error.Description.Contains("User name"))
       .ToArray();

        return IdentityResult.Failed(filteredErrors);
      }

      if (request.Roles.Count != 0)
      {
        await _userManager.AddToRolesAsync(user, request.Roles);
      }

      return result;
    }

    public async Task<bool> ValidateUserAsync(UserForAuthDto request)
    {
      _user = await _userManager.FindByEmailAsync(request.Email);

      var result = _user != null && await _userManager.CheckPasswordAsync(_user, request.Password);

      if (!result)
        return false;

      return result;

    }
    private SigningCredentials GetSignInCredentials()
    {
      var jwtSettings = _configuration.GetSection("JwtSetting");
      var key = Encoding.UTF8.GetBytes(jwtSettings["secretKey"]!);
      var secret = new SymmetricSecurityKey(key);
      return new SigningCredentials(secret, SecurityAlgorithms.HmacSha256);
    }

    private async Task<List<Claim>> GetClaims(User user)
    {
      var claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Name, user.UserName!)
            };

      var roles = await _userManager
          .GetRolesAsync(user);

      foreach (var role in roles)
      {
        claims.Add(new Claim(ClaimTypes.Role, role));
      }
      return claims;
    }

    private JwtSecurityToken GenerateTokenOptions(SigningCredentials signinCredentials,
        List<Claim> claims)
    {
      var jwtSettings = _configuration.GetSection("JwtSetting");

      var tokenOptions = new JwtSecurityToken(
              issuer: jwtSettings["validIssuer"],
              audience: jwtSettings["validAudience"],
              claims: claims,
              expires: DateTime.Now.AddMinutes(Convert.ToDouble(jwtSettings["expires"])),
              signingCredentials: signinCredentials);

      return tokenOptions;
    }
    private string GenerateRefreshToken()
    {
      var randomNumber = new byte[32];
      using (var rng = RandomNumberGenerator.Create())
      {
        rng.GetBytes(randomNumber);
        return Convert.ToBase64String(randomNumber);
      }
    }
    private ClaimsPrincipal GetPrincipalFromExpiredToken(string token)
    {
      var jwtSettings = _configuration.GetSection("JwtSetting");
      var secretKey = jwtSettings["secretKey"];

      var tokenValidationParameters = new TokenValidationParameters
      {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings["validIssuer"],
        ValidAudience = jwtSettings["validAudience"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey!))
      };

      var tokenHandler = new JwtSecurityTokenHandler();
      SecurityToken securityToken;

      var principal = tokenHandler.ValidateToken(token, tokenValidationParameters,
          out securityToken);

      var jwtSecurityToken = securityToken as JwtSecurityToken;
      if (jwtSecurityToken is null ||
          !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256,
          StringComparison.InvariantCultureIgnoreCase))
      {
        throw new SecurityTokenException("Invalid token.");
      }
      return principal;
    }

    public async Task<TokenDto> RefreshTokenAsync(TokenDto tokenDto)
    {
      var principal = GetPrincipalFromExpiredToken(tokenDto.AccessToken);
      var user = await _userManager.FindByNameAsync(principal.Identity!.Name!);

      if (user is null ||
          user.RefreshToken != tokenDto.RefreshToken ||
          user.RefreshTokenExpiryTime <= DateTime.Now)
        throw new Exception("Invalid client request.The tokenDto has some invalid values.");

      _user = user;
      return await CreateTokenAsync(populateExp: false, user);
    }

    public async Task CreateAndSendConfirmationEmailAsync(User user)
    {
      var token = await _userManager.GenerateEmailConfirmationTokenAsync(user);
      var encodedToken = WebUtility.UrlEncode(token);
      var confirmationLink = $"https://localhost:7288/verify-email?userId={user.Id}&token={encodedToken}";

      var mailMessage = new MailMessage
      {
        From = new MailAddress(_mailSettings.SenderEmail!, _mailSettings.SenderName),
        Subject = "Email Doğrulama",
        Body = $"Lütfen hesabınızı doğrulamak için aşağıdaki linke tıklayın:\n\n{confirmationLink}",
        IsBodyHtml = false
      };

      mailMessage.To.Add(user.Email!);

      using (var client = new SmtpClient(_mailSettings.SmtpServer, _mailSettings.SmtpPort))
      {
        client.Credentials = new NetworkCredential(_mailSettings.SenderEmail, _mailSettings.SenderPassword);
        client.EnableSsl = true;

        await client.SendMailAsync(mailMessage);
      }
    }
    public async Task<IdentityResult> ConfirmEmailAsync(string userId, string token)
    {
      var user = await _userManager.FindByIdAsync(userId);
      if (user == null)
        return IdentityResult.Failed(new IdentityError { Description = "User could not found." });


      // Decode the token
      var decodedToken = WebUtility.UrlDecode(token);

      var result = await _userManager.ConfirmEmailAsync(user, decodedToken);
      return result;
    }

    public async Task<User?> GetUserByEmailAsync(string email)
    {
      return await _userManager.FindByEmailAsync(email);
    }

    public async Task ForgotPasswordAsync(User user)
    {
      var code = _random.Next(0, 10000).ToString("D4");
      var expiryTime = DateTime.UtcNow.AddMinutes(10);

      var resetCodeEntry = new VerificationCode
      {
        UserId = user.Id,
        Code = code,
        ExpiryTimeUtc = expiryTime,
        IsUsed = false
      };

      _context.PasswordResetCodes.Add(resetCodeEntry);
      await _context.SaveChangesAsync();

      //old way:
      // var token = await _userManager.GeneratePasswordResetTokenAsync(user);
      // var encodedToken = WebUtility.UrlEncode(token);
      // var confirmationLink = $"https://localhost:7288/forgot-password?userId={user.Id}&token={encodedToken}";

      var mailMessage = new MailMessage
      {
        From = new MailAddress(_mailSettings.SenderEmail!, _mailSettings.SenderName),
        Subject = "Şifre Sıfırlama Kodu",
        Body = $"Şifrenizi sıfırlamak için doğrulama kodunuz: <{code}>\nBu kod 10 dakika geçerlidir.",
        IsBodyHtml = false
      };

      mailMessage.To.Add(user.Email!);

      using (var client = new SmtpClient(_mailSettings.SmtpServer, _mailSettings.SmtpPort))
      {
        client.Credentials = new NetworkCredential(_mailSettings.SenderEmail, _mailSettings.SenderPassword);
        client.EnableSsl = true;

        await client.SendMailAsync(mailMessage);
      }
    }

    public async Task<IdentityResult> ResetPasswordAsync(ResetPasswordDto request)
    {
      var validateTokenAndGetUserId = ValidateResetToken(request.Token);
      if (validateTokenAndGetUserId == null)
        return IdentityResult.Failed(new IdentityError { Description = "Invalid token." });

      var user = await _userManager.FindByIdAsync(validateTokenAndGetUserId);

      if (user == null)
      {
        return IdentityResult.Failed(new IdentityError { Description = "User could not found." });
      }

      var identityResetToken = await _userManager.GeneratePasswordResetTokenAsync(user);

      var result = await _userManager.ResetPasswordAsync(user, identityResetToken, request.Password);

      return result;

    }

    public async Task<bool> VerifyResetCode(VerifyCodeDto request, User user)
    {
      var resetCodeEntry = await _context.PasswordResetCodes
        .FirstOrDefaultAsync(prc => prc.UserId == user.Id &&
                                     prc.Code == request.VerificationCode &&
                                     !prc.IsUsed &&
                                     prc.ExpiryTimeUtc > DateTime.UtcNow);

      if (resetCodeEntry == null)
      {
        return false;
      }

      resetCodeEntry.IsUsed = true;

      await _context.SaveChangesAsync();

      return true;
    }

    public string GenerateSecureResetToken(string userId)
    {
      var tokenBytes = new byte[32];
      using (var rng = RandomNumberGenerator.Create())
      {
        rng.GetBytes(tokenBytes);
      }

      // base64'e format 
      var token = Convert.ToBase64String(tokenBytes)
                         .Replace("+", "")
                         .Replace("/", "")
                         .Replace("=", "");

      var cacheKey = $"ResetToken_{token}";
      _memoryCache.Set(cacheKey, userId, TimeSpan.FromMinutes(10));

      return token;
    }

    public string? ValidateResetToken(string token)
    {
      var cacheKey = $"ResetToken_{token}";
      if (_memoryCache.TryGetValue(cacheKey, out string? userId))
      {
        return userId;
      }

      return null;
    }
    public void InvalidateResetToken(string resetToken)
    {
        if (string.IsNullOrWhiteSpace(resetToken))
            return;

        _memoryCache.Remove($"ResetToken_{resetToken}");
    }

  }
}
