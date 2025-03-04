package com.niuma.common.base;

/**
 * 两种不同类型对象的比较器接口
 * @param <T> 对象1的类型
 * @param <U> 对象2的类型
 */
public interface Comparable2<T, U> {
    /**
     * 两种不同类型对象相比较
     * @param a 对象1
     * @param b 对象2
     * @return -1：a在b之前，0：a与b位置相同，1：a在b之后
     */
    int compare(T a, U b);
}
