using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using AutoMapper;
using login_signup_backend.dtos;
using login_signup_backend.interfaces;
using login_signup_backend.models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace login_signup_backend.services
{
  public class AuthService : IAuthService
  {
    private readonly IMapper _mapper;
    private readonly UserManager<User> _userManager;
    private readonly IConfiguration _configuration;
    private User? _user;

    public AuthService(IMapper mapper, UserManager<User> userManager,IConfiguration configuration)
    {
      _mapper = mapper;
      _userManager = userManager;
      _configuration = configuration;
    }

    public async Task<string> CreateTokenAsync()
    {
      var signinCredentials = GetSignInCredentials();
      var claims = await GetClaims();
      var tokenOptions = GenerateTokenOptions(signinCredentials, claims);

      return new JwtSecurityTokenHandler().WriteToken(tokenOptions);
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
        return IdentityResult.Failed(new IdentityError
        {
          Code = "CreateUserError",
          Description = "Could not create user."
        });
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

    private async Task<List<Claim>> GetClaims()
    {
      var claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Name, _user!.UserName!)
            };

      var roles = await _userManager
          .GetRolesAsync(_user);

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
  }
}