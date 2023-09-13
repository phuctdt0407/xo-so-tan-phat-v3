namespace TANPHAT.CRM.Models
{
    public class JwtSetting
    {
        public string Key { get; set; }
        public string Issuer { get; set; }
        public string Audience { get; set; }
        public int ExpiresDay { get; set; }
        public UserSessionInfo UserInfo { get; set; }
        public bool Flag { get; set; }
    }
}