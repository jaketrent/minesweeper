var mm = angular.module('mm', []);

mm.controller('BoardCtrl', ['$scope', '$http', function ($scope, $http) {
  $http.get('/ws/board/16/16/easy')
    .success(function (data) {
      $scope.board = data;
    })
    .error(function (data) {
      alert('Error!');
    });

  $scope.toggle = function ($event, cell) {
    angular.element($event.target).children('.result').toggleClass('hide');
  };
}]);
