require("version.nut");
class GSLogger extends GSController {}

function MainClass::Start()
{
	GSController.Sleep(1);

	local last_loop_date = GSDate.GetCurrentDate();
	local month_passed = 0;
	while (true) {
		local loop_start_tick = GSController.GetTick();

		// Reached new year/month?
		local current_date = GSDate.GetCurrentDate();
		if (last_loop_date != null) {
			if (month != GSDate.GetMonth(last_loop_date)) {
				month_passed++;
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

function MainClass::EndOfQuarter()
{
	for (local c_id = GSCompany.COMPANY_FIRST; c_id <= GSCompany.COMPANY_LAST; c_id++) {
		local mode = GSCompanyMode(c_id);
		local stats = {
			name = GSCompany.GetName(c_id),
			loanAmount = GSCompany.GetLoanAmount(),
			maxLoanAmount = GSCompany.GetMaxLoanAmount(),
			bankBalance = GSCompany.GetBankBalance(c_id),
			quarterlyIncome = GSCompany.GetQuarterlyIncome(c_id, GSCompany.EARLIEST_QUARTER),
			quarterlyExpenses = GSCompany.GetQuarterlyExpenses(c_id, GSCompany.EARLIEST_QUARTER),
			quarterlyCargoDelivered = GSCompany.GetQuarterlyCargoDelivered(c_id, GSCompany.EARLIEST_QUARTER),
			quarterlyPerformanceRating = GSCompany.GetQuarterlyPerformanceRating(c_id, GSCompany.EARLIEST_QUARTER),
			quarterlyCompanyValue = GSCompany.GetQuarterlyCompanyValue(c_id, GSCompany.EARLIEST_QUARTER)
		};

		GSLog.Info(stats.tostring());
	}
}