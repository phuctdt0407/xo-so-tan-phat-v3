-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM trigger_update_salepoint();
-- ================================
DROP TRIGGER IF EXISTS trigger_update_salepoint ON "SalePointLog";
CREATE TRIGGER trigger_update_salepoint BEFORE UPDATE ON "SalePointLog"
FOR EACH ROW EXECUTE PROCEDURE crm_report_trigger_update_salepoint();