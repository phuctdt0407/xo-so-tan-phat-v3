using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using TANPHAT.CRM.Client;
using TANPHAT.CRM.Models;

namespace TANPHAT.CRM.Middleware
{
    public class JWTMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IOptions<JwtSetting> _jwtConfig;
        private IUserClient _userClient;
        private UserSessionInfo currentUser;

        public JWTMiddleware(RequestDelegate next, IOptions<JwtSetting> jwtConfig, UserSessionInfo userSessionInfo, IUserClient userClient)
        {
            _next = next;
            _jwtConfig = jwtConfig;
            currentUser = userSessionInfo;
            _userClient = userClient;
        }

        public async Task Invoke(HttpContext context)
        {
            var token = context.Request.Headers["Authorization"].FirstOrDefault()?.Split(" ").Last();
            if (token != null)
                attachAccountToContext(context, token);
            await _next(context);
        }

        private void attachAccountToContext(HttpContext context, string token)
        {
            try
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                var tokenHandler1 = new JwtSecurityTokenHandler();
                var jwtReadToken = tokenHandler1.ReadJwtToken(token);
                var jwtExpValue = long.Parse(jwtReadToken.Claims.FirstOrDefault(x => x.Type == "exp").Value);
                DateTime expirationTime = DateTimeOffset.FromUnixTimeSeconds(jwtExpValue).DateTime;
                int checkExp = DateTime.Compare(DateTime.Now.AddMinutes(1), expirationTime);
                var userId = jwtReadToken.Claims.FirstOrDefault(x => x.Type == "Id").Value;
                var key = Encoding.ASCII.GetBytes(_jwtConfig.Value.Key);
                var cookieOptions = new CookieOptions
                {
                    HttpOnly = false,
                    Expires = DateTime.UtcNow.AddDays(_jwtConfig.Value.ExpiresDay)
                };
                //Check exp
                if (checkExp > 0)
                {
                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Subject = new ClaimsIdentity(new[] { new Claim("Id", userId) }),
                        Issuer = _jwtConfig.Value.Issuer,
                        Audience = _jwtConfig.Value.Audience,
                        Expires = DateTime.Now.AddDays(_jwtConfig.Value.ExpiresDay),
                        SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                    };
                    var tokenn = tokenHandler.CreateToken(tokenDescriptor);
                    var testToken = tokenHandler.WriteToken(tokenn).ToString();

                    tokenHandler.ValidateToken(testToken, new TokenValidationParameters
                    {
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = new SymmetricSecurityKey(key),
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ClockSkew = TimeSpan.Zero,
                        ValidIssuer = _jwtConfig.Value.Issuer,
                        ValidAudience = _jwtConfig.Value.Audience
                    }, out SecurityToken validatedToken);

                    context.Response.Cookies.Append("AUTH_", testToken, cookieOptions);
                }
                else
                {
                    tokenHandler.ValidateToken(token, new TokenValidationParameters
                    {
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = new SymmetricSecurityKey(key),
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ClockSkew = TimeSpan.Zero,
                        ValidIssuer = _jwtConfig.Value.Issuer,
                        ValidAudience = _jwtConfig.Value.Audience
                    }, out SecurityToken validatedToken);
                }
                currentUser.UserId = Int32.Parse(userId);
            }
            catch
            {
                currentUser.UserId = -1;
                currentUser.UserRoleId = -1;
            }
        }
    }
}
