using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using KTHub.Core.Helper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using TANPHAT.CRM.Client;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Auth;
using TANPHAT.CRM.Domain.Models.User;
using TANPHAT.CRM.Helpers;
using TANPHAT.CRM.Models;

namespace TANPHAT.CRM.Controllers.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private IAuthClient _authClient;
        private IUserClient _userClient;
        private readonly IOptions<JwtSetting> _jwtConfig;
        private MailHelper mailHelper;
        private UserSessionInfo currentUser;


        public AuthController(IAuthClient authClient, IUserClient userClient, IOptions<JwtSetting> jwtConfig, IOptions<MailSetting> mailSetting, UserSessionInfo userSessionInfo)
        {
            _authClient = authClient;
            _userClient = userClient;
            _jwtConfig = jwtConfig;
            mailHelper = new MailHelper(mailSetting.Value);
            currentUser = userSessionInfo;
        }

        private string GenerateJwtToken(int userId)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_jwtConfig.Value.Key);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[] { new Claim("Id", userId.ToString()) }),
                Issuer = _jwtConfig.Value.Issuer,
                Audience = _jwtConfig.Value.Audience,
                Expires = DateTime.Now.AddDays(_jwtConfig.Value.ExpiresDay),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }

        [AllowAnonymous]
        [HttpPost("Login")]
        public async Task<object> CheckLogin(CheckLoginReq req)
        {
            if (ModelState.IsValid)
            {
                var result = (await _authClient.CheckLogin(req)).Data;
                if (result.Id > 0)
                {
                    var tokenString = GenerateJwtToken(result.Id);
                    result.Token = tokenString;
                    var cookieOptions = new CookieOptions
                    {
                        HttpOnly = false,
                        Expires = DateTime.UtcNow.AddDays(_jwtConfig.Value.ExpiresDay)
                    };
                    HttpContext.Response.Cookies.Append("AUTH_", tokenString, cookieOptions);
                    return result;
                }
                return result;
            }
            return new LoginRes()
            {
                Id = -1,
                Message = "Tên đăng nhập hoặc mật khẩu không được bỏ trống"
            };
        }

        [AllowAnonymous]
        [HttpPost("ForgotPassword")]
        public async Task<object> ForgotPassword(ForgotPasswordReq model)
        {
            var res = (await _authClient.ForgotPassword(model)).Data;
            if (res.IsNotNull() && res.Id > 0)
            {
                model.NewPassword = res.Message;
                var res2 = await mailHelper.SendMailChangePassword(model);

                if(res2.IsNotNull() && res2.Id > 0)
                {
                    return res2;
                }
                else
                {
                    return new ReturnMessage
                    {
                        Id = -1,
                        Message = "Có lỗi xảy ra, thử lại"
                    };
                }
            }
            return res;
        }

        [Authorize]
        [HttpGet("GetSession")]
        public async Task<UserSessionInfo> GetSession()
        {
            if (currentUser.UserId > 0)
            {
                var userInfo = (await _userClient.GetUserSessionInfo(new UserDetailReq
                {
                    UserId = currentUser.UserId
                })).Data;
                if (userInfo.IsNotNull())
                {
                    currentUser.UserId = userInfo.UserId;
                    currentUser.UserRoleId = userInfo.UserRoleId;
                    currentUser.Account = userInfo.Account;
                    currentUser.FullName = userInfo.FullName;
                    currentUser.Email = userInfo.Email;
                    currentUser.UserTitleId = userInfo.UserTitleId;
                    currentUser.UserTitleName = userInfo.UserTitleName;
                    currentUser.IsSuperAdmin = userInfo.IsSuperAdmin;
                    currentUser.IsManager = userInfo.IsManager;
                    currentUser.IsStaff = userInfo.IsStaff;
                    currentUser.SalePointId = userInfo.SalePointId;
                    currentUser.ShiftDistributeId = userInfo.ShiftDistributeId;
                    currentUser.SubUserTitle = userInfo.SubUserTitle;
                    _jwtConfig.Value.Flag = true;
                }
                return currentUser;
            }
            else
            {
                return currentUser;
            }
        }

        [Authorize]
        [HttpGet("GetUserPermission")]
        public async Task<object> GetUserPermission(int userRoleId)
        {
            var obj = new UserPermissionReq
            {
                UserRoleId = userRoleId
            };
            var res = await _authClient.GetUserPermission(obj);
            return res;
        }

        [Authorize]
        [HttpGet("GetFirstPageShow")]
        public async Task<object> GetFirstPageShow(int userRoleId)
        {
            var obj = new GetFirstPgaeShowReq
            {
                UserRoleId = userRoleId
            };
            var res = await _authClient.GetFirstPageShow(obj);
            return res;
        }

        [Authorize]
        [HttpPost("ChangePassword")]
        public async Task<object> ChangePassword(ChangePasswordReq model)
        {
            var res = await _authClient.ChangePassword(model);
            return res;
        }

        //[Authorize]
        [HttpPost("Logout")]
        public object Logout()
        {
            currentUser = new UserSessionInfo();
            return new ReturnMessage
            {
                Id = 1,
                Message = "Đăng xuất thành công"
            };
        }
    }
}
