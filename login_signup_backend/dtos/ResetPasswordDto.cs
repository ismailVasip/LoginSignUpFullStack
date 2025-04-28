using System.ComponentModel.DataAnnotations;

namespace login_signup_backend.dtos
{
    public class ResetPasswordDto
    {
        [Required(ErrorMessage = "UserId is required!")]
        public string UserId { get; init; } = string.Empty;

        [Required(ErrorMessage = "Token is required!")]
        public string Token { get; init; } = string.Empty;

        [Required(ErrorMessage = "Password is required!")]
        public string Password { get; init; } = string.Empty;

        [Compare("Password", ErrorMessage = "Passwords are not matched!")]
        public string ConfirmPassword { get; init; } = string.Empty;
    }
}