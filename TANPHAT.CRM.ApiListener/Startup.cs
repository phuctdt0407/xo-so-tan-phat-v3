using KTHub.Core.Listener.Cotroller;
using KTHub.Core.Services;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Rewrite;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;
using TANPHAT.CRM.Business;
using TANPHAT.CRM.Provider;

namespace TANPHAT.CRM.ApiListener
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

            services.AddControllers();

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "ENEST.Listener", Version = "v1" });
            });

            services.ConfigurePOCO<ConsumerConfigs>(Configuration);

            services.AddSingleton<IAuthBusiness, AuthBusiness>();
            services.AddSingleton<IAuthProvider, AuthProvider>();

            services.AddSingleton<IUserBusiness, UserBusiness>();
            services.AddSingleton<IUserProvider, UserProvider>();

            services.AddSingleton<IActivityBusiness, ActivityBusiness>();
            services.AddSingleton<IActivityProvider, ActivityProvider>();

            services.AddSingleton<IBaseDDLBusiness, BaseDDLBusiness>();
            services.AddSingleton<IBaseDDLProvider, BaseDDLProvider>();

            services.AddSingleton<IReportBusiness, ReportBusiness>();
            services.AddSingleton<IReportProvider, ReportProvider>();

            services.AddSingleton<ISalePointBusiness, SalePointBusiness>();
            services.AddSingleton<ISalePointProvider, SalePointProvider>();
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseSwagger();
            app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "ENEST.Listener v1"));

            var option = new RewriteOptions();
            option.AddRedirect("^$", "swagger");
            app.UseRewriter(option);

            app.UseMiddleware<RequestBodyStoringMiddleware>();

            //app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
