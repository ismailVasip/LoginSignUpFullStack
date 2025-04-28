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
                return BadRequest(new { message = "Payload cannot be null" });

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                        .SelectMany(v => v.Errors)
                                        .Select(e => e.ErrorMessage)
                                        .ToList();

                return BadRequest(new { message = "Validation Failed", errors });
            }

            var result = await _authService.RegisterUserAsync(request);

            if (!result.Succeeded)
            {
                var errors = result.Errors.Select(e => e.Description).ToList();
                return BadRequest(new { message = "Registration Failed", errors });
            }

            var user = await _authService.GetUserByEmailAsync(request.Email);
            if (user == null)
            {
                return BadRequest(new { message = "An error occurred while retrieving the user to send email." });
            }
            await _authService.CreateAndSendConfirmationEmailAsync(user);


            return StatusCode(201, new { message = "Registration successful. Please confirm your email." });
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

        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordDto request)
        {
            try
            {
                if (request == null)
                    return BadRequest("Payload cannot be null");

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                if (string.IsNullOrEmpty(request.Email))
                {
                    return BadRequest(new { message = "Please check your email address." });
                }
                var user = await _authService.GetUserByEmailAsync(request.Email);
                if (user == null)
                {
                    return Ok(new { message = "User could not found!" });
                }

                await _authService.ForgotPasswordAsync(user);

                return Ok(new { message = "Email sent." });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordDto request)
        {
            try
            {
                if (request == null)
                    return BadRequest("Payload cannot be null");

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                if (request.Password != request.ConfirmPassword)
                {
                    return BadRequest(new { message = "Passwords are not matched!" });
                }

                var result = await _authService.ResetPasswordAsync(request);

                if (result.Succeeded)
                {
                    return Ok(new { message = "Password reset successfully." });
                }

                var errors = result.Errors.Select(e => e.Description);
                return BadRequest(new { message = "Password reset failed!", errors });

            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Something is happened: {ex.Message}" });
            }
        }
    }
}