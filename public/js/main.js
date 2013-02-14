var mm = angular.module('mm', []);

mm.controller('BoardCtrl', ['$scope', '$http', function ($scope, $http) {

  var util = {
    genUID: function () {
      ("0000" + (Math.random()*Math.pow(36,4) << 0).toString(36)).substr(-4)  
    }
  };

  function Cell(val) {
    return {
      id: util.genUID(),
      val: val,
      cleared: false,
      clear: function () {
        this.cleared = true;
      },
      isBomb: function () {
        return val == "*";
      },
      isCleared: function () {
        return this.cleared;
      },
      isBlank: function () {
        return val == 0;
      },
      isNum: function () {
        return val > 0;
      }
    }
  }

  function Game() {
    return {
      board: null,
      clearCell: function (cell) {
        cell.clear();
        if (cell.isBomb()) {
          this.clearAllBombs()
        }
      },
      clearAllBombs: function () {
        _(this.board.cells).each(function (row) {
          _(row).each(function (cell) {
            if (cell.isBomb()) {
              cell.clear();
            }
          });
        });
      },
      start: function () {
        function convert_board(board) {
          var conv_board = {
            cells: []
          };
          _(board).each(function (row, rowIndx) {
            conv_board.cells.push([]); // new row
            _(row).each(function (col, colIndx) {
              conv_board.cells[rowIndx].push(new Cell(col));
            });
          });
          return conv_board;
        }
        var self = this;

        $http.get('/ws/board/10/10/easy')
          .success(function (data) {
            self.board = convert_board(data);
          })
          .error(function (data) {
            alert('Error!');
          });
      }
    }    
  }

  $scope.game = new Game()
  $scope.game.start();

  
}]);

