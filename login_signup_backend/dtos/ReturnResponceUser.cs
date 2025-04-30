
namespace login_signup_backend.dtos
{
    public class ReturnResponceUser
    {
        public string? FullName { get; init; }
        public string? Email { get; init; }
        public TokenDto? Tokens { get; init; }
        public bool? IsEmailConfirmed { get; init; }
    }
}