using login_signup_backend.dtos;
using Microsoft.AspNetCore.Identity;

namespace login_signup_backend.interfaces
{
    public interface IAuthService
    {
        Task<IdentityResult> RegisterUserAsync(UserForRegistrationDto request);
        Task<bool> ValidateUserAsync(UserForAuthDto request);
        Task<TokenDto> CreateTokenAsync(bool populateExp);
        Task<TokenDto> RefreshTokenAsync(TokenDto tokenDto);
    }
}