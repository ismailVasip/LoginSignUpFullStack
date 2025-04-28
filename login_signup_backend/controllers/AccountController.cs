using login_signup_backend.dtos;
using login_signup_backend.interfaces;
using login_signup_backend.models;
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

            var user = await _authService.GetUserByEmailAsync(request.Email);
            if (user == null)
            {
                return BadRequest( "An error occurred while retrieving the user to send email.");
            }
            await _authService.CreateAndSendConfirmationEmailAsync(user);


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

            if (!await _authService.ValidateUserAsync(request))
                return Unauthorized();//401

            var tokenDto = await _authService.CreateTokenAsync(populateExp: true);

            return Ok(tokenDto);
        }
        [HttpPost("refresh")]
        public async Task<IActionResult> Refresh([FromBody] TokenDto tokenDto)
        {
            if (tokenDto == null)
                return BadRequest("TokenDto cannot be null");

            var tokenDtoToReturn = await _authService
                .RefreshTokenAsync(tokenDto);

            return Ok(tokenDtoToReturn);
        }

        [HttpPost("confirm-email")]
        public async Task<IActionResult> ConfirmEmail([FromQuery] string userId, [FromQuery] string token)
        {
            if (string.IsNullOrWhiteSpace(userId) || string.IsNullOrWhiteSpace(token))
                return BadRequest("Id or token cannot be null or empty.");

            var result = await _authService.ConfirmEmailAsync(userId, token);

            if (result.Succeeded)
                return Ok("Email is confirmed.");
            else
            {
                var errorDescriptions = string.Join(", ", result.Errors.Select(e => e.Description));

                return BadRequest($"Email confirmation failed. Errors: {errorDescriptions}");
            }
        }
    }
}