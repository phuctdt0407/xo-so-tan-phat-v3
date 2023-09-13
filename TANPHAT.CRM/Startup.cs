
using System.Text;
using KTHub.Core.Client;
using KTHub.Core.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using TANPHAT.CRM.Client;
using TANPHAT.CRM.Hubs;
using TANPHAT.CRM.Middleware;
using TANPHAT.CRM.Models;

namespace TANPHAT.CRM
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.Configure<Appsettings>(Configuration.GetSection("Environment"));
            services.Configure<JwtSetting>(Configuration.GetSection("Jwt"));
            services.Configure<MailSetting>(Configuration.GetSection("MailSetting"));
            services.ConfigurePOCO<ApiConfigs>(Configuration);
            services.AddSingleton<UserSessionInfo>();

            services.AddSingleton<IAuthClient, AuthClient>();
            services.AddSingleton<IUserClient, UserClient>();
            services.AddSingleton<IActivityClient, ActivityClient>();
            services.AddSingleton<IBaseDDLClient, BaseDDLClient>();
            services.AddSingleton<IReportClient, ReportClient>();
            services.AddSingleton<ISalePointClient, SalePointClient>();
            services.AddControllersWithViews();

            services.AddCors(options =>
            {
                options.AddPolicy("AllowAllOrigins",
                    builder => builder.AllowAnyOrigin());
            });

            services.AddSession(options =>
            {
                options.Cookie.HttpOnly = false;
                options.Cookie.IsEssential = true;
            });

            #region Authentication
            services.AddAuthentication(option =>
            {
                option.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                option.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(options =>
            {
                options.RequireHttpsMetadata = false;
                options.SaveToken = true;
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = false,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = Configuration["Jwt:Issuer"],
                    ValidAudience = Configuration["Jwt:Audience"],
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Jwt:Key"])) //Configuration["JwtToken:SecretKey"]
                };
            });
            #endregion

            services.AddMvc()
                .AddJsonOptions(options => options.JsonSerializerOptions.PropertyNamingPolicy = null);

            services.AddSignalR();
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }
            app.UseHttpsRedirection();

            app.UseStaticFiles();

            app.UseCors("AllowAllOrigins");

            app.UseMiddleware<JWTMiddleware>();

            app.UseRouting();

            app.UseAuthentication();

            app.UseAuthorization();

            app.UseSession();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();

                endpoints.MapControllerRoute(
                    "Catch-All",
                    "{*url}",
                    new { controller = "Home", action = "Index" });

                endpoints.MapHub<ChatHub>("/chathub");
            });
        }
    }
}
