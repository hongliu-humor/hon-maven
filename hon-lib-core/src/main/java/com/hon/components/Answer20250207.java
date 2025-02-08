package com.hon.components;

import java.util.Arrays;
import java.util.stream.Collectors;

public class Answer20250207 {

    public static void main(String[] args) {
        int n = 4;
        int[][] matrix = generateMatrix(n);
        for (int i = 0; i < matrix.length; i++) {

        System.out.println(Arrays.stream(matrix[i]).boxed().collect(Collectors.toList()));
        }
    }

//    输入：n = 3
//    输出：[[1,2,3],[8,9,4],[7,6,5]]
    public static int[][] generateMatrix(int n) {

        int[][] matrix = new int[n][n];
        int target = n * n;
        // start point
        int x = 0, y = -1;
        //  0 不变 ； 1 正向变化； -1 反向变化
//        y 0 1 2
//        x 1 2
        int row = 0, col = 1;
        for(int i = 1; i <= target; i++) {
            if(x+row<0 || x+row>=n || y+col<0 || y+col>=n || matrix[x+row][y+col] != 0){
                if(row==0){
                    row = col; col = 0;
                }else{
                    col = -row; row = 0;
                }
            }
            x+=row; y+=col;
            matrix[x][y] = i;
        }


        return matrix;
    }
}
