require("version.nut");
class LoggerGS extends GSController {
	_debug_level = GSController.GetSetting("debug_level");

	function Start();
	function Save();
	function Load(version, data);
	function EndOfQuarter();
}

function LoggerGS::Save() {
	// No op.
	return {};
}

function LoggerGS::Load(version, data) {
	// No op.
}

function LoggerGS::Start()
{
	GSController.Sleep(1);

	local last_loop_date = GSDate.GetCurrentDate();
	local month_passed = 0;
	while (true) {
		local loop_start_tick = GSController.GetTick();

		local current_date = GSDate.GetCurrentDate();
		if (this._debug_level >= 1) {
			local year = GSDate.GetYear(current_date);
			local month = GSDate.GetMonth(current_date);
			local day = GSDate.GetDayOfMonth(current_date);
			GSLog.Info("Current Date: " + year + "-" + month + "-" + day);
		}
		if (last_loop_date != null) {
			if (GSDate.GetMonth(current_date) != GSDate.GetMonth(last_loop_date)) {
				month_passed++;
				GSLog.Info("Month Passed: " + month_passed);
				if (month_passed == 3) {
					this.EndOfQuarter();
					month_passed = 0;
				}
			}
		}
		last_loop_date = current_date;

		// Loop with a frequency of five days
		local ticks_used = GSController.GetTick() - loop_start_tick;
		GSController.Sleep(max(1, 5 * 74 - ticks_used));
	}
}

function LoggerGS::EndOfQuarter()
{
	for (local c_id = GSCompany.COMPANY_FIRST; c_id <= GSCompany.COMPANY_LAST; c_id++) {
		local mode = GSCompanyMode(c_id);
		GSLog.Info("cid=" + c_id + ",name=" + GSCompany.GetName(c_id));
		GSLog.Info("loadAmount=" + GSCompany.GetLoanAmount() +
			",maxLoanAmount=" + GSCompany.GetMaxLoanAmount() +
			",bankBalance=" + GSCompany.GetBankBalance(c_id) +
			",quarterlyIncome=" + GSCompany.GetQuarterlyIncome(c_id, GSCompany.EARLIEST_QUARTER) +
			",quarterlyExpenses=" + GSCompany.GetQuarterlyExpenses(c_id, GSCompany.EARLIEST_QUARTER) +
			",quarterlyCargoDelivered=" + GSCompany.GetQuarterlyCargoDelivered(c_id, GSCompany.EARLIEST_QUARTER) +
			",quarterlyPerformanceRating=" + GSCompany.GetQuarterlyPerformanceRating(c_id, GSCompany.EARLIEST_QUARTER) +
			",quarterlyCompanyValue=" + GSCompany.GetQuarterlyCompanyValue(c_id, GSCompany.EARLIEST_QUARTER)
		);
	}
}