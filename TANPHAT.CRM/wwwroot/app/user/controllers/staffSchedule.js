(function () {
    app.controller('User.staffSchedule', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', '$uibModal', 'dayOfWeek', 'dayOfWeekVN','shiftStatus',
        function ($scope, $rootScope, $state, viewModel, sortIcon, $uibModal, dayOfWeek, dayOfWeekVN, shiftStatus) {
            var vm = angular.extend(this, viewModel);
            var formatMonth = ['MM-YYYY', 'YYYY-MM'];
            vm.month = vm.params.distributeMonth;
            vm.thisMonth = moment(vm.month, formatMonth).format("MM-YYYY");

            var checkShift = function (date) {
                if (moment().format('DD') == moment(date).format('DD')) {
                    if (moment().format('HH:mm') > '21:00') return [1, 2]
                    if (moment().format('HH:mm') > '13: 30') return [1]
                }
                return []
            }

            vm.totalShiftInMonth = vm.listDistribute.length;
            vm.totalShiftToCurrent = vm.listDistribute.filter(x => moment(x.DistributeDate).diff(moment().add(-1, 'days')) < 0 || checkShift(x.DistributeDate).includes(x.ShiftId)).length

            

            vm.loadData = function () {
                vm.params.distributeMonth = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            vm.listStatus = angular.copy(shiftStatus);

            vm.openPopup = function (model = {}, start = {}) {
                var viewPath = baseAppPath + '/user/views/modal/';
                var modalHistoryLog = $uibModal.open({
                    templateUrl: viewPath + 'shiftDetail.html' + versionTemplate,
                    controller: 'User.shiftDetail as $vm',
                    backdrop: 'static',
                    size: 'md',
                    windowClass: 'remove-modal-footer',
                    resolve: {
                        viewModel: {
                            userOnShift: {
                                name: model.name,
                                userId: model.userId,
                            },
                            note: model.note,
                            shift: model.shift,
                            salePointId: model.salePointId,
                            distributeDate: moment(start).format("YYYY-MM-DD"),
                            listStaff: vm.listStaff
                        }
                    }
                });

                modalHistoryLog.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-footer').addClass('remove-modal-footer');
                    });
                });

                modalHistoryLog.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {
                        $state.reload();
                    }
                });
            }

            var init = function () {
                vm.listEvent = [];
                if (vm.listDistribute && vm.listDistribute.length > 0) {
                    vm.listDistribute.forEach(function (item) {
                        var name = vm.listStaff.filter(x => x.Id == item.UserId)[0];
                        var status = vm.listStatus.filter(x => x.Id == item.ShiftTypeId)[0];
                        if (name) {
                            var temp = {
                                "start": moment(item.DistributeDate).format('YYYY-MM-DD'),
                                "end": moment(item.DistributeDate).format('YYYY-MM-DD'),
                                "title": item.SalePointName+" - "+ (name ? name.Name : 'Nhân viên không tồn tại'),
                                "shift": item.ShiftId,
                                "userId": item.UserId,
                                "name": name ? (name.Name + item.SalePointName) : 'Nhân viên không tồn tại' + (status ? status.SName : ''),
                                "salePointId": item.SalePointId,
                                "note": item.Note,
                            };
                            vm.listEvent.push(temp);
                        }

                    })
                }
            }
            init();

            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
                customButtons: {
                    thisMonthButton: {
                        text: 'This month',
                        click: function () {
                            var month = moment().format('YYYY-MM');
                            if (month != vm.params.month) {
                                calendar.today()
                                //$state.go($state.current, { month: month }, { reload: false, notify: true });
                            }
                        }
                    }
                },
                headerToolbar: {
                    //left: 'prev thisMonthButton next',
                    left: 'thisMonthButton',
                    center: 'title',
                    right: ''
                },
                locale: 'vi',
                initialDate: vm.month,
                buttonIcons: false,
                weekNumbers: false,
                navLinks: true,
                //editable: false,
                //eventStartEditable: false,
                //eventDurationEditable: false,
                dayMaxEvents: true,
                dayMaxEventRows: true,
                nowIndicator: true,
                now: moment().format('YYYY-MM-DD HH:mm:ss'),
                views: {
                    dayGridMonth: {
                        dayMaxEvents: 4,
                        dayMaxEventRows: 4
                    },
                    timeGridWeek: {
                        dayMaxEvents: 4,
                        dayMaxEventRows: 4
                    }
                },
                //eventDidMount: function (info) {
                //},

                events: vm.listEvent,
                eventOrder: ['shift'],
                eventTimeFormat: {
                    hour: '2-digit',
                    minute: '2-digit',
                    meridiem: false,
                    hour12: false
                },
                eventClick: function (event) {
                    //vm.openPopup(event.event.extendedProps, event.event.start); 
                },
                eventClassNames: function (event) {
                    if (event.event.extendedProps.shift == 1) {
                        return ['morning-shift']
                    } else {
                        return ['evening-shift']
                    }
                },
                progressiveEventRendering: true
            });
            $(document).ready(function () {
                setTimeout(function () {
                    calendar.render();
                    $(".fc-thisMonthButton-button").html('Tháng này');
                    $(".fc-toolbar-title").html($(".fc-toolbar-title").html().replace('t', "T"))

                    $(".fc-thisMonthButton-button").click(function () {
                        vm.month = moment();
                        vm.loadData();
                    });
                }, 500)
            });

        }]);
})();
