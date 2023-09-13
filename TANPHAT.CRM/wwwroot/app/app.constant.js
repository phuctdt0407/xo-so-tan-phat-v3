app.constant('daySchedule', [
    { Id: 0, Day: 'MON', Time: '12:00' },
    { Id: 1, Day: 'TUE',Time: '12:00' },
    { Id: 2, Day: 'WED', Time: '12:00' },
    { Id: 3, Day: 'THU', Time: '12:00' },
    { Id: 4, Day: 'FRI', Time: '12:00' },
    { Id: 5, Day: 'SAT', Time: '12:00' },
    { Id: 6, Day: 'SUN', Time: '12:00' }
]);

app.constant('dayOfWeek', [ // lam giong voi .day() cua moment()
    { Id: 1, Day: 'MON' },
    { Id: 2, Day: 'TUE' },
    { Id: 3, Day: 'WED' },
    { Id: 4, Day: 'THU' },
    { Id: 5, Day: 'FRI' },
    { Id: 6, Day: 'SAT' },
    { Id: 0, Day: 'SUN' }
]);


app.constant('extraPaymentType', [
    { Id: 1, Sum:0, IsSum:true,Name: 'Tăng ca', TransactionTypeId: 6, Css:'bg-overtime'},
    { Id: 2, Sum:0, IsSum: true, Name: 'Thưởng', TransactionTypeId: 7, Css: 'bg-reward' },
    { Id: 3, Sum:0, IsSum: false, Name: 'Phạt', TransactionTypeId: 4, Css: 'bg-prevent' },
    { Id: 4, Sum: 0, IsSum: false, Name: 'Ứng lương', TransactionTypeId: 5, Css: '' },
    { Id: 5, Sum: 0, IsSum: false, Name: 'Nợ nhân viên', TransactionTypeId: 14, Css: 'bg-blue' }
]);


app.constant('dayOfWeekVN', [ // lam giong voi .day() cua moment()
    { Id2: 7, Id: 1, Name: 'Chủ nhật', SName: 'CN' },
    {Id2: 1, Id: 2, Name: 'Thứ 2' , SName:'T2'},
    {Id2: 2, Id: 3, Name: 'Thứ 3' , SName:'T3'},
    {Id2: 3, Id: 4, Name: 'Thứ 4' , SName:'T4'},
    {Id2: 4, Id: 5, Name: 'Thứ 5' , SName:'T5'},
    {Id2: 5, Id: 6, Name: 'Thứ 6' , SName:'T6'},
    { Id2: 6, Id: 0, Name: 'Thứ 7', SName:'T7'}
]);

app.constant('shiftStatus', [
    { Id: 1, Name: "Ca gốc", SName: ' ' },
    { Id: 2, Name: "Làm bù", SName: ' (LB)' },
    { Id: 3, Name: "Tăng ca", SName: ' (TC)' },
]);

app.constant('shiftStatus2', [
    { Id: 1, Name: "Ca 1", SName: ' (C1)' },
    { Id: 2, Name: "Ca 2", SName: ' (C2)' },

]);

app.constant('optionPriority', [
    { Id: 1, Name: '1', Value: 1 },
    { Id: 2, Name: '2', Value: 2 },
    { Id: 3, Name: '3', Value: 3 },
    { Id: 4, Name: '4', Value: 4 },
    { Id: 5, Name: '5', Value: 5 }
]);

app.constant('optionRequest', [
    { Id: 201, Name: 'Waiting for approval'},
    { Id: 202, Name: 'Approved'},
    { Id: 300, Name: 'Rejected'},
    { Id: 500, Name: 'Cancelled' }
]);

app.constant('optionSelect', [
    { Id: 1, text: "Select 10", value: 10 },
    { Id: 2, text: "Select 50", value: 50 },
    { Id: 3, text: "Select 100", value: 100 },
    { Id: 4, text: "Select 200", value: 200 }
])

app.constant('listDateType', [
    { name: "None", value: "" },
    { name: "Start date", value: "start_date" },
    { name: "End date", value: "end_date" }
]);

app.constant('transitionType', [
    { Id: 0, Name: "Tất cả"},
    { Id: 1, Name: "Chuyển vé" },
    { Id: 2, Name: "Nhận vé" },
    { Id: 3, Name: "Trả ế"}
]);

app.constant('studentActiveStatus', [
    { Id: 1, Name: "Active" },
    { Id: 2, Name: "Inacive" }
]);

app.constant('duration', [
    { Id: 1, Name: '25 minutes' },
    { Id: 2, Name: '50 minutes' }
]);

app.constant('typeOfItem', [
    { Id: 1, Name: 'công cụ' },
    { Id: 2, Name: 'máy móc' },
    
]);

app.constant('listClassStatus', [
    { Id: 0, Name: 'All status' },
    { Id: 1, Name: 'Not Started Yet' },
    { Id: 2, Name: 'On Going' },
    //{ Id: 3, Name: 'Cancel' },
    //{ Id: 4, Name: 'Deferred' },
    { Id: 5, Name: 'Done' }
]);

app.constant('listClassStatusFull', [
    { Id: 1, Name: 'Not Started Yet' },
    //{ Id: 2, Name: 'On Going' },
    { Id: 3, Name: 'Cancel' },
    { Id: 4, Name: 'Deferred' },
    { Id: 5, Name: 'Done' }
]);

app.constant('sortIcon', ['fa fa-sort', 'fa fa-sort-down', 'fa fa-sort-up'])

app.constant('listStudentType', [
    {
        Id: 2,
        Value: "Regular"
    },
    {
        Id: 1,
        Value: "Trial"
    }
]);

app.constant('phoneCode', [
    {
        Id: 1,
        Value: "(+84) VN"
    },
    {
        Id: 2,
        Value: "(+63) PHL"
    }
]);

app.constant('ActionDeferBy', [
    {
        Id: 1,
        Value: "Teacher"
    },
    {
        Id: 2,
        Value: "Student"
    }
]);

app.constant('PeriodTime', [
    {
        Id: 1,
        Value: "< 1"
    },
    {
        Id: 2,
        Value: "1 <= and <3"
    },
    {
        Id: 3,
        Value: ">=3"
    }
]);

app.constant('callType', [
    {
        Id: 1,
        Value: "Outbound Call"
    },
    {
        Id: 2,
        Value: "Inbound Call"
    }
]);