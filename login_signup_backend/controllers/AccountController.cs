using login_signup_backend.dtos;
using login_signup_backend.interfaces;
using Microsoft.AspNetCore.Mvc;

namespace login_signup_backend.controllers
{
    [ApiController]
    [Route("api/auth")]
    public class AccountController : ControllerBase
    {
        private readonly IAuthService _authService;

        public AccountController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> RegisterUser([FromBody] UserForRegistrationDto request)
        {
            if (request == null)
                return BadRequest("Payload cannot be null");

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _authService.RegisterUserAsync(request);

            if (!result.Succeeded)
            {
                foreach (var error in result.Errors)
                {
                    ModelState.TryAddModelError(error.Code, error.Description);
                }
                return BadRequest(ModelState);
            }

            return StatusCode(201);
        }

        [HttpPost("login")]
        public async Task<IActionResult> LoginUser([FromBody] UserForAuthDto request)
        {
            if (request == null)
                return BadRequest("Payload cannot be null");

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if(!await _authService.ValidateUserAsync(request))
                return Unauthorized();//401

            return Ok(
                new 
                {
                    Token = await _authService.CreateTokenAsync()
                }
            );
        }
    }
}