-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM trigger_insert_log();
-- ================================
DROP TRIGGER IF EXISTS trigger_insert_log ON "InventoryLog";
CREATE TRIGGER trigger_insert_log BEFORE INSERT OR UPDATE ON "InventoryLog"
FOR EACH ROW EXECUTE PROCEDURE crm_insert_log_inventory_log();

