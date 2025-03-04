package com.niuma.common.utils;

import com.niuma.common.base.Comparable2;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 通用实用工具类
 *
 * @author wujian
 * @email 393817707@qq.com
 * @date 2023.03.14
 */
public final class CommonUtils {
    private CommonUtils() {}

    // 大写字母表
    private static final char[] CapitalLetters = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

    // 小写字母表
    private static final char[] LowercaseLetters = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };

    // 数字表
    private static final char[] Numbers = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };

    //
    public static final int CODE_CAPITAL = 0x01;

    //
    public static final int CODE_LOWERCASE = 0x02;

    //
    public static final int CODE_NUMBER = 0x04;

    //
    public static final int CODE_ALL = (0x01 | 0x02 | 0x04);

    /**
     * 判定整数
     * @param value 整数
     * @return 当value为null或者为0时返回false，否则返回true
     */
    public static boolean predicate(Integer value) {
        if (value == null)
            return false;
        if (value.equals(0))
            return false;
        return true;
    }

    /**
     * 生成随机码
     * @param length 随机码长度
     * @param codeMask 随机码类型掩码，如：CODE_CAPITAL | CODE_NUMBER
     * @return 随机码
     */
    public static String generateRandomCode(int length, int codeMask) {
        if (length < 1)
            return null;
        int types = 0;
        char[][] arr = new char[3][];
        if ((codeMask & CODE_CAPITAL) != 0) {
            arr[types] = CapitalLetters;
            types++;
        }
        if ((codeMask & CODE_LOWERCASE) != 0) {
            arr[types] = LowercaseLetters;
            types++;
        }
        if ((codeMask & CODE_NUMBER) != 0) {
            arr[types] = Numbers;
            types++;
        }
        if (types == 0)
            return null;
        StringBuilder sb = new StringBuilder();
        int tmp = 0;
        char[] characters = null;
        ThreadLocalRandom generator = ThreadLocalRandom.current();
        for (int i = 0; i < length; i++) {
            tmp = generator.nextInt(types);
            characters = arr[tmp];
            tmp = generator.nextInt(characters.length);
            sb.append(characters[tmp]);
        }
        return sb.toString();
    }

    // 检查重复接口
    public interface DuplicateTester {
        /**
         * 检查编码是否重复(已存在)
         * @param code 生成的随机编码
         * @return 重复-true，不重复-false
         */
        boolean testDuplicate(String code);
    }

    /**
     * 生成随机编码
     * @param length 随机码长度
     * @param codeMask 随机码类型掩码，如：CODE_CAPITAL | CODE_NUMBER
     * @param tester 重复测试接口
     * @return 随机码
     */
    public static String generateRandomCode(int length, int codeMask, DuplicateTester tester) {
        String code = null;
        int count = 0;
        while (true) {
            code = CommonUtils.generateRandomCode(length, codeMask);
            if (!tester.testDuplicate(code))
                break;
            count++;
            if (count > 100)
                return null;
        }
        return code;
    }

    /**
     * 生成随机密码
     * @return 随机密码
     */
    public static String generatePassword(int length) {
        if (length < 1)
            return null;
        // 包含2~5个特殊字符
        final char[] SpecialCharacters = { '~', '!', '@', '#', '$', '%', '^', '&', '*' };
        ThreadLocalRandom generator = ThreadLocalRandom.current();
        int nums = 2 + generator.nextInt(4);
        int pos1 = 0;
        int pos2 = 0;
        StringBuilder sb = new StringBuilder(generateRandomCode(length, CODE_ALL));
        for (int i = 0; i < nums; i++) {
            pos1 = generator.nextInt(9);
            pos2 = generator.nextInt(sb.length() + 1);
            sb.insert(pos2, SpecialCharacters[pos1]);
        }
        return sb.toString();
    }

    /**
     * 顺序依次从Map映射表中取出值
     * @param dataMap 数据映射表
     * @param sequences 数据映射表关键字顺序表
     * @param <T1> 数据映射表关键字泛型
     * @param <T2> 数据映射表值泛型
     * @return 数据映射表中的值
     */
    public static <T1, T2> T2 getInSequence(Map<T1, T2> dataMap, LinkedList<T1> sequences) {
        if (dataMap == null || sequences == null)
            return null;
        if (sequences.isEmpty()) {
            for (Map.Entry<T1, T2> entry : dataMap.entrySet())
                sequences.add(entry.getKey());
        }
        T2 value = null;
        while ((value == null) && (!sequences.isEmpty())) {
            T1 key = sequences.pop();
            value = dataMap.get(key);
        }
        return value;
    }

    /**
     * 获取当前日期的整形格式
     * @return 返回当前日期，如2022年6月12日返回20220612
     */
    public static int getCurrentIntDate() {
        return getIntDate(Calendar.getInstance());
    }

    /**
     * 日期转换成整形格式
     * @param date 日期
     * @return 返回整形格式日期，如2022年6月12日返回20220612
     */
    public static int getIntDate(Date date) {
        if (date == null)
            throw new IllegalArgumentException("Input date can't be null.");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return getIntDate(calendar);
    }

    /**
     * 日期转换成整形格式
     * @param calendar 日期
     * @return 返回整形格式日期，如2022年6月12日返回20220612
     */
    public static int getIntDate(Calendar calendar) {
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);
        month += 1;
        int date = year * 100 + month;
        date = date * 100 + day;
        return date;
    }

    /**
     * 将日期转换换成整形格式
     * @param date 日期，格式：yyyy-MM-dd
     * @return 整数格式日期，如2022年6月12日返回20220612
     */
    public static int getIntDate(String date) {
        if (date == null || date.length() != 10)
            return -1;
        StringBuilder sb = new StringBuilder();
        sb.append(date, 0, 4);
        sb.append(date, 5, 7);
        sb.append(date.substring(8));
        int ret = -1;
        try { ret = Integer.parseInt(sb.toString()); } catch (Exception ex) { }
        return ret;
    }

    public static String getNowTimestamp() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        return sdf.format(new Date());
    }

    /**
     * 处理搜索关键字
     * @param keyword 关键字
     * @return 处理后的关键字
     */
    public static String processKeyword(String keyword) {
        if (keyword == null)
            return null;
        keyword = StringUtils.trim(keyword);
        if (StringUtils.isEmpty(keyword))
            keyword = null;
        else
            keyword = "%" + keyword + "%";
        return keyword;
    }

    /**
     * 判断文件名是否为图像文件格式
     * @param fileName 文件名
     * @return 是-true，否-false
     */
    public static boolean isImageFormat(String fileName) {
        if (StringUtils.isEmpty(fileName))
            return false;
        int pos = fileName.lastIndexOf('.');
        if (pos < 0 || pos == (fileName.length() - 1))
            return false;
        boolean test = false;
        String suffix = fileName.substring(pos + 1);
        String[] imgFormats = { "bmp", "jpg", "jpeg", "png", "tga", "tiff" };
        for (int i = 0; i < imgFormats.length; i++) {
            if (suffix.compareToIgnoreCase(imgFormats[i]) == 0) {
                test = true;
                break;
            }
        }
        return test;
    }

    /**
     * 二分查找，查找target在array中的位置索引
     * @param array 对象列表
     * @param target 查找目标
     * @param comparer 比较器
     * @param <T> 对象类型
     * @param <U> 目标类型
     * @return 位置索引或者-1(未找到)
     */
    public static <T, U> int binarySearch(List<T> array, U target, Comparable2<T, U> comparer) {
        if ((array == null) || (target == null) || array.isEmpty())
            return -1;
        int i = 0;
        int j = array.size() - 1;
        int m = 0;
        int c = 0;
        while (i <= j) {
            // 一半取整
            m = (j + i) >>> 1;
            T obj = array.get(m);
            c = comparer.compare(obj, target);
            if (c == -1) {
                // 目标在右边
                i = m + 1;
            } else if (c == 1) {
                // 目标在左边
                j = m - 1;
            } else {
                // 找到结果
                return m;
            }
        }
        // 找不到，则返回-1
        return -1;
    }

    /**
     * 判定字符串全部是数字
     * @param str 字符串
     * @return 是-true，否-false
     */
    public static boolean isNumeric(String str) {
        if (StringUtils.isEmpty(str))
            return false;
        // 正则表达式 \d 是数字字符，+ 表示一次或多次
        return str.matches("\\d+");
    }

    /**
     * 判断字符串是否为有效ip地址
     * @param ip 输入字符串
     * @return true-有效ip地址，false-非法ip地址
     */
    public static boolean isValidIP(String ip) {
        final String IP_REGEX = "([1-9]|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3}";
        Pattern pattern = Pattern.compile(IP_REGEX);
        Matcher matcher = pattern.matcher(ip);
        return matcher.matches();
    }

    public static void main(String[] args) {
        String code = generateRandomCode(10, CODE_ALL);
        System.out.println(code);
    }
}