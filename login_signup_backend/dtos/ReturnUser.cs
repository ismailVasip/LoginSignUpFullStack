
namespace login_signup_backend.dtos
{
    public class ReturnUser
    {
        public string FullName { get; init; } = string.Empty;
        public string Email { get; init; } = string.Empty;
        public string PhoneNumber { get; init; } = string.Empty;
        public bool IsEmailConfirmed { get; init; } = false;

    }
}