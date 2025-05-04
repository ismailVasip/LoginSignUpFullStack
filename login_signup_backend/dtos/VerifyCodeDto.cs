using System.ComponentModel.DataAnnotations;

namespace login_signup_backend.dtos
{
    public class VerifyCodeDto
    {
        [Required(ErrorMessage = "Email is required!")]
        [EmailAddress]
        public string Email { get; init; } = string.Empty;

        [Required(ErrorMessage = "Verification code is required!")]
        [StringLength(4, MinimumLength = 4)]
        public string VerificationCode { get; init; } = string.Empty;
    }
}