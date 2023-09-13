using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Auth;
using TANPHAT.CRM.Models;

namespace TANPHAT.CRM.Helpers
{
    public class MailHelper
    {
        private MailSetting mailSetting { get; set; }
        public MailHelper(MailSetting mailSetting)
        {
            this.mailSetting = mailSetting;
        }
        public async Task<ReturnMessage> SendMailChangePassword(ForgotPasswordReq model)
        {
            
            var senderName = "TẤN PHÁT CRM";
            var contentBody = string.Empty;
            string templateDocument = Path.Combine(@"wwwroot/templates/html/optTemplate.html");
            using (var sr = new StreamReader(templateDocument))
            {
                contentBody = sr.ReadToEnd();
            }

            Dictionary<string, string> dc = new Dictionary<string, string>();
            dc.Add("##thoigian", model.Time);
            dc.Add("##thietbi", model.SystemInfo);
            dc.Add("##matkhau", model.NewPassword);
            //dc.Add("##OTP", model.OTP);
            foreach (var item in dc)
            {
                contentBody = contentBody.Replace(item.Key, item.Value);
            }

            var mailSubject = "[ĐẠI LÝ VÉ SỐ TẤN PHÁT] ĐỔI MẬT KHẨU THÀNH CÔNG " ;
            var resSend = await SendEmailSync(mailSubject, contentBody, model.Email, mailSetting.SenderAccount, mailSetting.SenderPassword, senderName);
            Console.WriteLine($"resSend {resSend.Message}");
            return resSend;
        }

        public async Task<ReturnMessage> SendEmailSync(string subject, string body, string emailReceiver, string senderMail, string senderPassword, string senderName)
        {
            
            var res = new ReturnMessage() { Id = 1, Message = "Success" };
            try
            {
                // SmtpClient smtpClient = new SmtpClient("smtp.office365.com", 587);

                SmtpClient smtpClient = new SmtpClient("smtp.gmail.com", 587);
                smtpClient.EnableSsl = true;
                smtpClient.UseDefaultCredentials = false;
                smtpClient.Credentials = (ICredentialsByHost)new NetworkCredential(senderMail, senderPassword);

                AlternateView avHtml = AlternateView.CreateAlternateViewFromString(body, null, MediaTypeNames.Text.Html);
                //var trial_footer = System.IO.Path.Combine(@"wwwroot/templates/img/trial_footer.png");

                //LinkedResource inline = new LinkedResource(trial_footer, MediaTypeNames.Image.Jpeg);

                //inline.ContentId = "trial_footer";

                //avHtml.LinkedResources.Add(inline);

                MailMessage mailMessage = new MailMessage();

                mailMessage.AlternateViews.Add(avHtml);
                mailMessage.Subject = subject;
                mailMessage.SubjectEncoding = Encoding.UTF8;
                mailMessage.IsBodyHtml = true;
                mailMessage.Body = body;
                mailMessage.BodyEncoding = Encoding.UTF8;
                mailMessage.From = new MailAddress(senderMail, senderName);
                mailMessage.To.Add(emailReceiver);
                smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                //mailMessage.Bcc.Add("phu.nguyen@theenest.edu.vn");
                //mailMessage.Bcc.Add("nhat.tran@theenest.edu.vn");
                await smtpClient.SendMailAsync(mailMessage);
                smtpClient = (SmtpClient)null;
                mailMessage = (MailMessage)null;
            }
            catch (SmtpFailedRecipientsException ex)
            {
                var exStr = string.Empty;
                for (int i = 0; i < ex.InnerExceptions.Length; i++)
                {
                    SmtpStatusCode status = ex.InnerExceptions[i].StatusCode;
                    exStr += ex.InnerExceptions[i].StatusCode + ex.InnerExceptions[i].FailedRecipient;
                }
                res.Id = -1;
                res.Message = exStr;
            }
            catch (Exception ex)
            {
                res.Id = -1;
                res.Message = "Message: " + ex.Message + "### InnerException: " + ex.InnerException;
            }
            return res;
        }
    }
}
