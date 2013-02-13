var mm = angular.module('mm', []);

mm.controller('BoardCtrl', ['$scope', '$http', function ($scope, $http) {

  function convert_board(board) {
    var conv_board = {
      cells: []
    };
    _(board).each(function (row, rowIndx) {
      conv_board.cells.push([]); // new row
      _(row).each(function (col, colIndx) {
        conv_board.cells[rowIndx].push({
          val: col,
          visible: false
        });
      });
    });
    return conv_board;
  }

  $http.get('/ws/board/16/16/easy')
    .success(function (data) {
      $scope.board = convert_board(data);
    })
    .error(function (data) {
      alert('Error!');
    });

  $scope.toggle = function ($event, cell) {
    cell.visible = true;
  };
}]);

