using login_signup_backend.dtos;
using login_signup_backend.models;
using Microsoft.AspNetCore.Identity;

namespace login_signup_backend.interfaces
{
    public interface IAuthService
    {
        Task<IdentityResult> RegisterUserAsync(UserForRegistrationDto request);
        Task<bool> ValidateUserAsync(UserForAuthDto request);
        Task<TokenDto> CreateTokenAsync(bool populateExp,User user);
        Task<TokenDto> RefreshTokenAsync(TokenDto tokenDto);
        Task CreateAndSendConfirmationEmailAsync(User user);
        Task<IdentityResult> ConfirmEmailAsync(string userId, string token);
        Task<User?> GetUserByEmailAsync(string email);
        Task ForgotPasswordAsync(User user);
        Task<bool> VerifyResetCode(VerifyCodeDto request,User user);
        string GenerateSecureResetToken(string userId);
        string? ValidateResetToken(string token);
        void InvalidateResetToken(string resetToken);
        Task<IdentityResult> ResetPasswordAsync(ResetPasswordDto request);
    }
}