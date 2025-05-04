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
                var errors = result.Errors?.Select(e => e.Description).ToList() ?? [];
                return BadRequest(new
                {
                    message = "Registration failed",
                    errors = errors.Count != 0 ? errors : ["An unknown error occurred"]
                });
            }

            var user = await _authService.GetUserByEmailAsync(request.Email);
            if (user == null)
            {
                return BadRequest(new { message = "An error occurred while retrieving the user to send email." });
            }
            await _authService.CreateAndSendConfirmationEmailAsync(user);


            return StatusCode(201, new
            {
                message = "Registration successful. Please confirm your email.",
                user = new ReturnResponceUser
                {
                    FullName = user.FullName,
                    Email = user.Email,
                    Tokens = await _authService.CreateTokenAsync(populateExp: true, user),
                    IsEmailConfirmed = user.EmailConfirmed
                }
            });
        }

        [HttpPost("login")]
        public async Task<IActionResult> LoginUser([FromBody] UserForAuthDto request)
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

            if (!await _authService.ValidateUserAsync(request))
                return Unauthorized(new { message = "User could not found!" });//401

            var user = await _authService.GetUserByEmailAsync(request.Email);

            var tokenDto = await _authService.CreateTokenAsync(populateExp: true, user!);

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
                    return BadRequest(new { message = "Payload cannot be null" });

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values
                                        .SelectMany(v => v.Errors)
                                        .Select(e => e.ErrorMessage)
                                        .ToList();

                    return BadRequest(new { message = "Validation Failed", errors });
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

                try
                {
                    await _authService.ForgotPasswordAsync(user);

                    return Ok(new { message = "The password recovery code has been sent to your email address." });

                }
                catch (Exception)
                {
                    return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while sending the code." });
                }
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
                    return BadRequest(new { message = "Payload cannot be null" });

                if (!ModelState.IsValid)
                {
                    var modelErrors = ModelState.Values
                                        .SelectMany(v => v.Errors)
                                        .Select(e => e.ErrorMessage)
                                        .ToList();

                    return BadRequest(new { message = "Validation Failed", errors = modelErrors });
                }
                if (request.Password != request.ConfirmPassword)
                {
                    return BadRequest(new { message = "Passwords are not matched!" });
                }

                var result = await _authService.ResetPasswordAsync(request);

                if (result.Succeeded)
                {
                    _authService.InvalidateResetToken(request.Token);
                    return Ok(new { message = "Password reset successfully. You can login now." });
                }

                var errors = result.Errors.Select(e => e.Description);
                return BadRequest(new { message = "Password reset failed!", errors });

            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Something is happened: {ex.Message}" });
            }
        }

        [HttpPost("verify-reset-code")]
        public async Task<IActionResult> VerifyResetCode([FromBody] VerifyCodeDto request)
        {
            if (request == null)
                return BadRequest(new { message = "Payload cannot be null" });

            if (!ModelState.IsValid)
            {
                var modelErrors = ModelState.Values
                                    .SelectMany(v => v.Errors)
                                    .Select(e => e.ErrorMessage)
                                    .ToList();

                return BadRequest(new { message = "Validation Failed", errors = modelErrors });
            }
            var user = await _authService.GetUserByEmailAsync(request.Email);
            if (user == null)
            {
                return BadRequest(new { message = "User could not found!" });
            }

            var result = await _authService.VerifyResetCode(request,user);

            if(!result)
            {
                return BadRequest(new { message = "Invalid reset code." });
            }

            var resetToken = _authService.GenerateSecureResetToken(user.Id);

            return Ok(new VerifyResetCodeResponseDto{ResetToken = resetToken});

        }
    }
}