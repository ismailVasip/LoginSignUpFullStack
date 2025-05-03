using login_signup_backend.dtos;

namespace login_signup_backend.interfaces
{
    public interface IUserService
    {
        Task<List<ReturnUser>> GetAllUsersAsync();
    }
}