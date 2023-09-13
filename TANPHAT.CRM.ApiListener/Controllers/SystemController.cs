using System;
using System.Collections.Generic;
using KTHub.Core.Listener.Cotroller;
using KTHub.Core.Listener.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using TANPHAT.CRM.Domain.Commons;

namespace TANPHAT.CRM.ApiListener.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SystemController : ControllerBase
    {
        private DbHelper dbHelper { get; set; }
        private IConfiguration _configuration { get; }

        public SystemController(IConfiguration configuration)
        {
            _configuration = configuration;
            dbHelper = new DbHelper(new ConnectionStrings()
            {
                DbCheckConfigs = new List<DbConnectionType>() {
                    new DbConnectionType() {
                        ConnectionName = DBCommon.TANPHATCRMConnStr,
                        DatabaseType = "POSTGRES"
                    }
                }
            }, _configuration);
        }

        [HttpGet("TestApi")]
        public object TestApi()
        {
            var str = dbHelper.GetDatabaseStatusInfos();
            return str;
        }

    }
}
