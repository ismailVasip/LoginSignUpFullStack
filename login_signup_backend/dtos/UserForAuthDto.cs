using System.ComponentModel.DataAnnotations;

namespace login_signup_backend.dtos
{
    public class UserForAuthDto
    {
        [Required(ErrorMessage = "Email field is required")]
        public string Email { get; init; } = string.Empty;

        [Required(ErrorMessage = "Password field is required")]
        public string Password { get; init; } = string.Empty;
    }
}