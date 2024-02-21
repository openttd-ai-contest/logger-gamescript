require("version.nut");
class LoggerGS extends GSController {
	_debug_level = GSController.GetSetting("debug_level");
    _end_year = GSController.GetSetting("end_year");
	
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
					this.EndOfQuarter(current_date);
					month_passed = 0;
				}
			}
		}
		last_loop_date = current_date;

		local ticks_used = GSController.GetTick() - loop_start_tick;
		GSController.Sleep(max(1, 5 * 74 - ticks_used));
	}
}

function LoggerGS::EndOfQuarter(current_date)
{
    local year = GSDate.GetYear(current_date);
    local month = GSDate.GetMonth(current_date);
    local day = GSDate.GetDayOfMonth(current_date);
	for (local c_id = GSCompany.COMPANY_FIRST; c_id <= GSCompany.COMPANY_LAST; c_id++) {
		local mode = GSCompanyMode(c_id);
		if (GSCompany.ResolveCompanyID(c_id) == GSCompany.COMPANY_INVALID) {
			continue;
		}
		local lastQuarter = GSCompany.CURRENT_QUARTER + 1;
		if (lastQuarter > GSCompany.EARLIEST_QUARTER) {
			continue;
		}
		GSLog.Info("date=" + year + "-" + month + "-" + day + ",cid=" + c_id + ",name=" + GSCompany .GetName(c_id));
		GSLog.Info("cid=" + c_id +
            ",date=" + year + "-" + month + "-" + day +
            ",loanAmount=" + GSCompany.GetLoanAmount() +
			",maxLoanAmount=" + GSCompany.GetMaxLoanAmount() +
			",bankBalance=" + GSCompany.GetBankBalance(c_id) +
			",quarterlyIncome=" + GSCompany.GetQuarterlyIncome(c_id, lastQuarter) +
			",quarterlyExpenses=" + GSCompany.GetQuarterlyExpenses(c_id, lastQuarter) +
			",quarterlyCargoDelivered=" + GSCompany.GetQuarterlyCargoDelivered(c_id, lastQuarter) +
			",quarterlyPerformanceRating=" + GSCompany.GetQuarterlyPerformanceRating(c_id, lastQuarter) +
			",quarterlyCompanyValue=" + GSCompany.GetQuarterlyCompanyValue(c_id, lastQuarter)
		);
	}
    if (year >= this._end_year) {
        GSLog.Info("done");
    }
}
