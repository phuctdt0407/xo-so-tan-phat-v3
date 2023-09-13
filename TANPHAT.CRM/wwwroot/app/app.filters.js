app.filter('workingFilter', function () {
    return function (input) {
        if (input === '' || input === null)
            return input;

        if (input === true) {
            return '<span class="badge badge-sm badge-success">Working</span>';
        } else {
            return '<span class="badge badge-sm badge-danger">Stopped</span>';
        }
    };
});

app.filter('typeCheckStatus', function () {
    return function (input) {
        if (input === '' || input === null)
            return input;

        switch (input) {
            //Khong chia du ca truc trong diem ban
            case 1:
                return '<i class="fa fa-exclamation-triangle" aria-hidden="true"></i>';
                break;
            //1 trong 2 ca nv chua nhap du thong tin 
            case 2:
                return '<i class="fa fa-circle-o-notch fa-spin" aria-hidden="true"></i>';
                break;
            //KHONG KHOP 
            case 3:
                return '<i class="fa fa-times btn-danger" aria-hidden="true"></i>';
                break;
            //KHOP
            case 4:
                return '<i class="fa fa-check btn-success" aria-hidden="true"></i>';
                break;
            default:
                return '';
                break;
        };
    }
})


app.filter('activeStatus', function () {
    return function (input) {
        if (input === '' || input === null)
            return input;

        if (input == 1) {
            return '<span class="badge badge-sm badge-success activeCustom">Chuyển vé</span>';
        } else {
            return '<span class="badge badge-sm badge-warning activeCustom">Nhận vé</span>';
        }
    };
});

app.filter('statusRequest', function () {
    return function (input) {
        if (input === '' || input === null)
            return input;

        switch (input) {
            case 100:
                return '<span class="badge badge-sm badge-info">New</span>';
                break;
            case 101:
                return '<span class="badge badge-sm badge-primary">Call back later</span>';
                break;
            case 201:
                return '<span class="badge badge-sm badge-warning">Waiting-For-Approval</span>';
                break;
            case 202:
                return '<span class="badge badge-sm badge-success">Approved</span>';
                break;
            case 300:
                return '<span class="badge badge-sm badge-danger">Rejected</span>';
                break;
            case 500:
                return '<span class="badge badge-sm badge-danger">Call fail</span>';
                break;
            default:
                return '';
                break;
        };
    };
});

app.filter('optionRequest', function () {
    return function (input) {
        if (input === '' || input === null)
            return input;

        switch (input) {
            case 201:
                return '<span class="badge badge-sm badge-warning label-info">Waiting for approval</span>';
                break;
            case 202:
                return '<span class="badge badge-sm badge-success label-info">Approved</span>';
                break;
            case 300:
                return '<span class="badge badge-sm badge-danger label-info">Rejected</span>';
                break;
            case 500:
                return '<span class="badge badge-sm badge-danger label-info">Cancelled</span>';
                break;
            default:
                return '';
                break;
        };
    };
});

app.filter('problemFilter', function () {
    return function (input) {
        if (input === '' || input === null)
            return input;

        switch (input) {
            case 1:
                return '<span class="badge badge-sm badge-danger">Not-Solved</span>';
                break;
            case 2:
                return '<span class="badge badge-sm badge-success">Solved</span>';
                break;
            case 3:
                return '<span class="badge badge-sm badge-warning">Solved</span>';
                break;
            default:
                return '';
                break;
        };
    };
});
app.filter('formatNumberFloatAvgReport', ['$filter', function ($filter) {
    return function (input) {
        if (input === '' || !input || isNaN(input)) {
            return '0';
        }
        else {
            var parts = input.toString().split(".");
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            if (parts[1]) {
                var first = parseInt(parts[1].substr(0, 1));
                if (parts[1].length > 1) {
                    var second = parseInt(parts[1].substr(1, 1));
                    if (second >= 0 && second < 5) {
                        parts[1] = first;
                    }
                    else {
                        if (first < 9) {
                            parts[1] = first + 1;
                        }
                        else {
                            if (parseInt(parts[0]) >= 0) {
                                return parseInt(parts[0]) + 1;
                            }
                            return parseInt(parts[0]) - 1;
                        }
                    }
                    if (parts[1] === 0) {
                        return parts[0];
                    }
                }
                else {
                    parts[1] = first;
                }
            }
            return parts.join(".");
        }
    };
}]);
app.filter('formatPercentFloat', ['$filter', function ($filter) {
    return function (input) {
        if (input === '' || !input || isNaN(input) || input == 0) {
            return '0%';
        }
        else {
            var parts = input.toString().split(".");
            if (parts.length > 1 && parts[1].length > 2) {
                input = $filter('number')(parseFloat(input), 2);
                parts = input.toString().split(".");
            }
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            return parts.join(".") + "%";
        }
    };
}]);
app.filter('formatNumberFloat', ['$filter', function ($filter) {
    return function (input) {
        if (input === '' || !input || isNaN(input)) {
            return '0';
        }
        else {
            var parts = input.toString().split(".");
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            return parts.join(".");
        }
    };
}]);
app.filter('formatPercent', ['$filter', function ($filter) {
    return function (input) {
        if (input === '' || !input || isNaN(input)) {
            return '0%';
        }
        else {
            if (parseInt(input) <= 0) {
                var inputParse1 = $filter('number')(parseFloat(input), 0);
                return inputParse1.replace(/\B(?=(\d{3})+(?!\d))/g, '.') + '%';
            }
            else {
                var inputParse2 = $filter('number')(parseFloat(input), 0);
                return inputParse2.replace(/\B(?=(\d{3})+(?!\d))/g, '.') + '%';
            }
        }
    };
}]);

app.filter('formatNumber', ['$filter', function ($filter) {
    return function (input) {
        if (input === '' || !input || isNaN(input)) {
            return '0';
        } else {
            return parseInt(input).toString().replace('.', ',').replace(/\B(?=(\d{3})+(?!\d))/g, '.');
        }
    };
}]);

app.filter('classType', function () {
    return function (input) {
        if (input === '' || input === null)
            return input;

        if (input === 1) {
            return '<span class="badge badge-md badge-warning label-info">Trial</span>';
        } else if (input === 2) {
            return '<span class="badge badge-md badge-info label-info">Regular</span>';
        }
    };
});

app.filter('classSessionType', function () {
    return function (input) {
        if (input === '' || input === null)
            return input;

        if (input === 1) {
            return '<span class="badge badge-md trial label-info">Trial</span>';
        } else if (input === 2) {
            return '<span class="badge badge-md regular label-info">Regular</span>';
        } else if (input === 3) {
            return '<span class="badge badge-md bonus label-info">Bonus</span>';
        } else {
            return '<span class="badge badge-md regular label-info">Make-up</span>';
        }
    };
});

app.filter('classStatus', function () {
    return function (input, isTeacher) {
        if (input === '' || input === null)
            return input;
        if (input === 1) {
            return '<span class="badge badge-md badge-primary label-info">Not Started Yet</span>';
        } else if (input === 2) {
            return '<span class="badge badge-md badge-purple label-info">On Going</span>';
        } else if (input === 3) {
            if (isTeacher) {
                return '<span class="badge badge-md badge-warning label-info">Absent</span>';
            }
            return '<span class="badge badge-md badge-danger label-info">Cancelled</span>';
        } else if (input === 4) {
            if (isTeacher) {
                return '<span class="badge badge-md badge-warning label-info">Absent</span>';
            }
            return '<span class="badge badge-md badge-warning label-info">Deferred</span>';
        } else if (input === 5) {
            return '<span class="badge badge-md badge-success label-info">Done</span>';
        } else if (input === 6) {
            return '<span class="badge badge-md badge-info label-info">Waiting For Make-up</span>';
        }
    };
});

app.filter('genderFilter', function () {
    return function (input) {
        if (input === 0) {
            return '<span class="badge badge-md badge-pink">Female</span>';
        } else if (input === 1) {
            return '<span class="badge badge-md badge-info">Male</span>';
        } else {
            return '<span class="badge badge-md badge-gray">Unknown</span>';
        }
    };
});

app.filter('yesNoFilter', function () {
    return function (input) {
        if (input) {
            return '<span class="badge badge-md yes-bg-color label-info">Yes</span>';
        } else {
            return '<span class="badge badge-md no-bg-color label-info">No</span>';
        }
    };
});
app.filter('formatCurrency',function (){
    return function (input){
        if(!input || input ===''||input ===null){
            return "";
        }else{
            return input.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")
        }
        
    }
})

app.filter('formatDate', function () {
    return function (input, formatStr) {
        var pattern = new RegExp(/\d+/);
        formatStr = formatStr ? formatStr : 'DD/MM/YYYY';

        if (!input || input === '' || input === null || !input || input === '01/01/0001') {
            return '';
        } else if (moment.isMoment(input)) {
            return input.isValid() ? input.format(formatStr) : '';
        } else if (moment(input).isValid()) {
            return moment(input).format(formatStr);
        } else if (pattern.test(input)) {
            var convertedDate = new Date(input.match(pattern)[0] * 1);
            return moment(convertedDate).format(formatStr);
        } else {
            return new Date(parseInt(input.substr(6)));
        }
    };
});
app.filter('formatDateTime', function () {
    return function (input, formatStr) {
        var pattern = new RegExp(/\d+/);
        formatStr = formatStr ? formatStr : 'HH:mm DD/MM/YYYY';

        if (!input || input === '' || input === null || !input || input === '00:00 01/01/0001') {
            return '';
        } else if (moment.isMoment(input)) {
            return input.isValid() ? input.format(formatStr) : '';
        } else if (moment(input).isValid()) {
            return moment(input).format(formatStr);
        } else if (pattern.test(input)) {
            var convertedDate = new Date(input.match(pattern)[0] * 1);
            return moment(convertedDate).format(formatStr);
        } else {
            return new Date(parseInt(input.substr(6)));
        }
    };
});

app.filter('formatDateTimeByHours', function () {
    return function (input, formatStr) {
        var pattern = new RegExp(/\d+/);
        formatStr = formatStr ? formatStr : 'HH:mm';

        if (!input || input === '' || input === null || !input || input === '00:00') {
            return '';
        } else if (moment.isMoment(input)) {
            return input.isValid() ? input.format(formatStr) : '';
        } else if (moment(input).isValid()) {
            return moment(input).format(formatStr);
        } else if (pattern.test(input)) {
            var convertedDate = new Date(input.match(pattern)[0] * 1);
            return moment(convertedDate).format(formatStr);
        } else {
            return new Date(parseInt(input.substr(6)));
        }
    };
});

app.filter('tel', function() {
    return function(input) {
        var regexObj = /^(?:\+?1[-. ]?)?(?:\(?([0-9]{3})\)?[-. ]?)?([0-9]{3})[-. ]?([0-9]{4})$/;
        if (regexObj.test(input)) {
            var parts = input.match(regexObj);
            var phone = "";
            phone += parts[1] + "-"+ parts[2] + "-" + parts[3];
            return phone;
        } else {
            //invalid phone number
            return input;
        }
    };
});

app.filter('callType', function () {
    return function (input) {
        if (input === '' || input === null)
            return input;

        if (input === 0) {
            return '<span class="badge badge-md badge-success label-info">Outbound</span>';
        } else if (input === 1) {
            return '<span class="badge badge-md badge-danger label-info">Inbound</span>';
        }else {
            return '<span class="badge badge-md badge-gray label-info">Unknow</span>';
        }
    };
});

app.filter('shift', function () {
    return function (input) {
        if (input === '' || input === null)
            return input;

        if (input === 1) {
            return '<span class="badge badge-md morning-shift label-info">Ca sáng</span>';
        } else {
            return '<span class="badge badge-md evening-shift label-info">Ca chiều</span>';
        }
    };
});

app.filter('userStatus', function () {
    return function (input) {
        if (input == false) {
            return '<span class="badge badge-md badge-danger label-info">Ngưng hoạt động</span>';
        } else {
            return '<span class="badge badge-md badge-success label-info">Hoạt động</span>';

        }
    };
});

app.filter('confirmStatus', function () {
    return function (input) {
        if (input == 1) {
            return '<span class="badge badge-md badge-warning label-info">Chờ xác nhận</span>';
        }
        else if (input == 2) {
            return '<span class="badge badge-md badge-success label-info">Đã xác nhận</span>';
        }
        else if (input == 3) {
            return '<span class="badge badge-md badge-danger label-info">Huỷ yêu cầu</span>';
        }
    };
});

app.filter('changeColor', function () {
    return function (input) {
        if (input < 0) {
            return '<span class="badge badge-md badge-success label-info">'+input+'</span>';
        }
        else if (input > 0) {
            return '<span class="badge badge-md badge-warning label-info">'+input+'</span>';
        }
        else if (input == null) {
            return '';
        }
    };
});

app.filter('confirmPayment', function () {
    return function (input) {
        if (input == false) {
            return '<span class="badge badge-md badge-warning label-info">Chờ xác nhận</span>';
        }
        else if (input == true) {
            return '<span class="badge badge-md badge-success label-info">Đã xác nhận</span>';
        }
    };
});

app.filter('detail', function () {
    return function (input) {
        if (input == false) {
            return '<span class="badge badge-md badge-danger label-info">Đóng</span>';
        } else {
            return '<span class="badge badge-md badge-success label-info">Xem</span>';
        }
    };
});

app.filter('transactionType', function () {
    return function (input) {
        if (input == 0) {
            return '';
        }else if (input == 1){
            return 'Chuyển vé';
        } else if (input == 2){
            return 'Nhận vé';
        }
        else {
            return 'Trả ế';
        }
    };
});



