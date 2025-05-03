using login_signup_backend.dtos;
using login_signup_backend.interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace login_signup_backend.controllers
{
    [ApiController]
    [Route("api/user")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;

    public UserController(IUserService userService)
    {
      _userService = userService;
    }

    [Authorize]
    [HttpGet]   
    public async Task<ActionResult<IEnumerable<ReturnUser>>> GetUsers()
    {
      var users = await _userService.GetAllUsersAsync();

      return Ok(users);//If there are no users
    }
  }
}