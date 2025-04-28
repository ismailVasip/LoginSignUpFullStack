using System.ComponentModel.DataAnnotations;

namespace login_signup_backend.dtos
{
    public class ForgotPasswordDto
    {
        [Required]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        public string Email { get; init; } = string.Empty;
    }
}