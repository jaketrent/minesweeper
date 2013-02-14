var mm = angular.module('mm', []);

mm.directive('right-click', ['$parse', function ($parse) {
  return function (scope, element, attr) {
    console.log('directive');
    element.bind('contextmenu', function (event) {
      console.log('contextmenu');
      event.preventDefault();
      var fn = $parse(attr['right-click']);
      scope.$apply(function () {
        fn(scope, {
          $event: event
        });
      });
      return false;
    });
  };
}]);

// document.oncontextmenu = function (e) {
//   console.log('on context menu' + e.which);
//   e.preventDefault();
//   return false;
// }

// mm.directive('right-click', function () {
//   return function (scope, element, attr) {
//     console.log('directive');
//     element.bind('contextmenu', function (event) {
//       console.log('contextmenu');
//       event.preventDefault();
//       var fn = scope.$eval(attr['right-click'])
//       return false;
//     });
//   };
// });

mm.controller('BoardCtrl', ['$scope', '$http', function ($scope, $http) {

  function Cell(val, x, y) {
    return {
      val: val,
      cleared: false,
      x: x,
      y: y,
      clear: function () {
        this.cleared = true;
      },
      isBomb: function () {
        return val == "B";
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
      flagCell: function (cell) {
        console.log('flagging cell');
        cell.clear();
      },
      clearCell: function (cell) {
        cell.clear();
        if (cell.isBomb()) {
          this.clearAllBombs()
        } else if (cell.isBlank()) {
          this.clearSurroundingCells(cell);
        }
      },
      cellAt: function (x, y) {
        return (x == -1 || y == -1) ? null : this.board.cells[y][x];
      },
      clearSurroundingCells: function (cell) {
        function clearIfValid(cell) {
          if (cell && !cell.isCleared()) { 
            this.clearCell(cell) 
          }
        }
        // W
        clearIfValid.call(this, this.cellAt(this.prevCol(cell.x), cell.y));
        // E
        clearIfValid.call(this, this.cellAt(this.nextCol(cell.x), cell.y));
        // N
        clearIfValid.call(this, this.cellAt(cell.x, this.upRow(cell.y)));
        // S
        clearIfValid.call(this, this.cellAt(cell.x, this.downRow(cell.y)));
        // NW
        clearIfValid.call(this, this.cellAt(this.prevCol(cell.x), this.upRow(cell.y)));
        // NE
        clearIfValid.call(this, this.cellAt(this.nextCol(cell.x), this.upRow(cell.y)));
        // SW
        clearIfValid.call(this, this.cellAt(this.prevCol(cell.x), this.downRow(cell.y)));
        // SE
        clearIfValid.call(this, this.cellAt(this.nextCol(cell.x), this.downRow(cell.y)));
      },
      prevCol: function (x) {
        return x > 0 ? x - 1 : -1;
      },
      nextCol: function (x) {
        return x < this.board.cells[0].length - 1 ? x + 1 : -1;
      },
      upRow: function (y) {
        return y > 0 ? y - 1 : -1;
      },
      downRow: function (y) {
        return y < this.board.cells.length - 1 ? y + 1 : -1;
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
        function convertBoard(board) {
          var convertedBoard = {
            cells: []
          };
          _(board).each(function (row, y) {
            convertedBoard.cells.push([]); // new row
            _(row).each(function (col, x) {
              convertedBoard.cells[y].push(new Cell(col == "*" ? "B" : col, x, y));
            });
          });
          return convertedBoard;
        }
        var self = this;

        $http.get('/ws/board/10/10/easy')
          .success(function (data) {
            self.board = convertBoard(data);
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

