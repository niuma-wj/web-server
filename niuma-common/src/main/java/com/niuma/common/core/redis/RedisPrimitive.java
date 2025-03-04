package com.niuma.common.core.redis;

import java.util.*;
import java.util.concurrent.TimeUnit;

import com.niuma.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.*;
import org.springframework.stereotype.Component;

/**
 * spring redis 缓存基本数据类型工具类
 * 用于支持跨平台的数据缓存
 *
 * @author wujian
 * @Email 393817707@qq.com
 * @Date 2024.10.30
 */
@SuppressWarnings(value = { "unchecked", "rawtypes" })
@Component
public class RedisPrimitive
{
    @Autowired
    public StringRedisTemplate redisTemplate;

    /**
     * 缓存String数值
     *
     * @param key 缓存的键值
     * @param value 缓存的值
     */
    public void set(String key, String value) {
        if (StringUtils.isEmpty(key) || StringUtils.isEmpty(value))
            return;
        this.redisTemplate.opsForValue().set(key, value);
    }

    public <T extends Number> void setNumber(String key, T value) {
        if (value != null)
            this.set(key, value.toString());
    }

    /**
     * 缓存String数值
     *
     * @param key 缓存的键值
     * @param value 缓存的值
     * @param timeout 时间
     * @param timeUnit 时间颗单位
     */
    public void set(String key, String value, Long timeout, final TimeUnit timeUnit) {
        if (StringUtils.isEmpty(key) || StringUtils.isEmpty(value))
            return;
        this.redisTemplate.opsForValue().set(key, value, timeout, timeUnit);
    }

    public <T extends Number> void setNumber(String key, T value, Long timeout, final TimeUnit timeUnit) {
        if (value != null)
            this.set(key, value.toString(), timeout, timeUnit);
    }

    /**
     * 获得String数值
     *
     * @param key 缓存键值
     * @return String数值
     */
    public String get(String key) {
        if (StringUtils.isEmpty(key))
            return null;
        return this.redisTemplate.opsForValue().get(key);
    }

    public Integer getInt(String key) {
        String str = this.get(key);
        if (StringUtils.isEmpty(str))
            return null;
        return Integer.valueOf(str);
    }

    public Long getLong(String key) {
        String str = this.get(key);
        if (StringUtils.isEmpty(str))
            return null;
        return Long.valueOf(str);
    }

    public Float getFloat(String key) {
        String str = this.get(key);
        if (StringUtils.isEmpty(str))
            return null;
        return Float.valueOf(str);
    }

    public Double getDouble(String key) {
        String str = this.get(key);
        if (StringUtils.isEmpty(str))
            return null;
        return Double.valueOf(str);
    }

    /**
     * 设置有效时间
     *
     * @param key Redis键
     * @param timeout 超时时间(秒)
     * @return true=设置成功；false=设置失败
     */
    public Boolean expire(final String key, final long timeout) {
        return expire(key, timeout, TimeUnit.SECONDS);
    }

    /**
     * 设置有效时间
     *
     * @param key Redis键
     * @param timeout 超时时间
     * @param unit 时间单位
     * @return true=设置成功；false=设置失败
     */
    public Boolean expire(final String key, final long timeout, final TimeUnit unit) {
        return redisTemplate.expire(key, timeout, unit);
    }

    /**
     * 获取有效时间
     *
     * @param key Redis键
     * @return 有效时间
     */
    public Long getExpire(final String key) {
        return redisTemplate.getExpire(key);
    }

    /**
     * 判断 key是否存在
     *
     * @param key 键
     * @return true 存在 false不存在
     */
    public Boolean hasKey(String key) {
        return redisTemplate.hasKey(key);
    }

    /**
     * 删除单个对象
     *
     * @param key
     */
    public Boolean delete(final String key) {
        return redisTemplate.delete(key);
    }

    /**
     * 删除集合对象
     *
     * @param collection 多个对象
     * @return
     */
    public Boolean delete(final Collection collection) {
        return redisTemplate.delete(collection) > 0;
    }

    /**
     * 缓存String列表数据
     *
     * @param key 缓存的键值
     * @param dataList 待缓存的列表数据
     * @return 缓存的数据个数
     */
    public Long setList(String key, List<String> dataList) {
        if (StringUtils.isEmpty(key))
            return 0L;
        if ((dataList == null) || dataList.isEmpty())
            return 0L;
        Long count = redisTemplate.opsForList().rightPushAll(key, dataList);
        return (count == null) ? 0 : count;
    }

    private <T extends Number> void toStringCollection(Collection<T> inList, Collection<String> outList) {
        for (T val : inList) {
            if (val == null)
                continue;
            outList.add(val.toString());
        }
    }

    private void toIntCollection(Collection<String> inList, Collection<Integer> outList) {
        for (String str : inList) {
            if (str == null)
                continue;
            try { outList.add(Integer.parseInt(str)); } catch (NumberFormatException ex) {}
        }
    }

    private void toLongCollection(Collection<String> inList, Collection<Long> outList) {
        for (String str : inList) {
            if (str == null)
                continue;
            try { outList.add(Long.parseLong(str)); } catch (NumberFormatException ex) {}
        }
    }

    private void toFloatCollection(Collection<String> inList, Collection<Float> outList) {
        for (String str : inList) {
            if (str == null)
                continue;
            try { outList.add(Float.parseFloat(str)); } catch (NumberFormatException ex) {}
        }
    }

    private void toDoubleCollection(Collection<String> inList, Collection<Double> outList) {
        for (String str : inList) {
            if (str == null)
                continue;
            try { outList.add(Double.parseDouble(str)); } catch (NumberFormatException ex) {}
        }
    }

    public <T extends Number> Long setNumberList(String key, List<T> dataList) {
        if ((dataList != null) && (!dataList.isEmpty())) {
            List<String> strList = new ArrayList<>(dataList.size());
            toStringCollection(dataList, strList);
            return setList(key, strList);
        }
        return 0L;
    }

    /**
     * 获取缓存的String列表
     *
     * @param key 缓存的键值
     * @return 缓存键值对应的数据
     */
    public List<String> getList(String key) {
        return redisTemplate.opsForList().range(key, 0, -1);
    }

    public List<Integer> getIntList(String key) {
        List<String> strList = this.getList(key);
        if (strList == null || strList.isEmpty())
            return null;
        List<Integer> retList = new ArrayList<Integer>(strList.size());
        toIntCollection(strList, retList);
        return retList;
    }

    public List<Long> getLongList(String key) {
        List<String> strList = this.getList(key);
        if (strList == null || strList.isEmpty())
            return null;
        List<Long> retList = new ArrayList<Long>(strList.size());
        toLongCollection(strList, retList);
        return retList;
    }

    public List<Float> getFloatList(String key) {
        List<String> strList = this.getList(key);
        if (strList == null || strList.isEmpty())
            return null;
        List<Float> retList = new ArrayList<Float>(strList.size());
        toFloatCollection(strList, retList);
        return retList;
    }

    public List<Double> getDoubleList(String key) {
        List<String> strList = this.getList(key);
        if (strList == null || strList.isEmpty())
            return null;
        List<Double> retList = new ArrayList<Double>(strList.size());
        toDoubleCollection(strList, retList);
        return retList;
    }

    /**
     * 缓存String集合
     *
     * @param key 缓存键值
     * @param dataSet 缓存的数据
     * @return 缓存数据的对象
     */
    public BoundSetOperations<String, String> setSet(String key, Set<String> dataSet) {
        BoundSetOperations<String, String> setOperation = redisTemplate.boundSetOps(key);
        Iterator<String> it = dataSet.iterator();
        while (it.hasNext()) {
            setOperation.add(it.next());
        }
        return setOperation;
    }

    public void sAdd(String key, String value) {
        this.redisTemplate.opsForSet().add(key, value);
    }

    public <T extends Number> void sAddNumber(String key, T value) {
        if (value != null)
            this.sAdd(key, value.toString());
    }

    /**
     * 获得缓存的set
     *
     * @param key
     * @return
     */
    public Set<String> getSet(String key) {
        return redisTemplate.opsForSet().members(key);
    }

    public Set<Integer> getIntSet(String key) {
        Set<String> strSet = this.getSet(key);
        if (strSet == null || strSet.isEmpty())
            return null;
        Set<Integer> retSet = new HashSet<>();
        toIntCollection(strSet, retSet);
        return retSet;
    }

    public Set<Long> getLongSet(String key) {
        Set<String> strSet = this.getSet(key);
        if (strSet == null || strSet.isEmpty())
            return null;
        Set<Long> retSet = new HashSet<>();
        toLongCollection(strSet, retSet);
        return retSet;
    }

    public Set<Float> getFloatSet(String key) {
        Set<String> strSet = this.getSet(key);
        if (strSet == null || strSet.isEmpty())
            return null;
        Set<Float> retSet = new HashSet<>();
        toFloatCollection(strSet, retSet);
        return retSet;
    }

    public Set<Double> getDoubleSet(String key) {
        Set<String> strSet = this.getSet(key);
        if (strSet == null || strSet.isEmpty())
            return null;
        Set<Double> retSet = new HashSet<>();
        toDoubleCollection(strSet, retSet);
        return retSet;
    }

    /**
     * 缓存Map
     *
     * @param key
     * @param dataMap
     */
    public void setMap(String key, Map<String, String> dataMap) {
        if (dataMap != null) {
            HashOperations<String, String, String> ops = redisTemplate.opsForHash();
            ops.putAll(key, dataMap);
        }
    }

    /**
     * 获得缓存的Map
     *
     * @param key
     * @return
     */
    public Map<String, String> getMap(String key) {
        HashOperations<String, String, String> ops = redisTemplate.opsForHash();
        return ops.entries(key);
    }

    /**
     * 往Hash中存入数据
     *
     * @param key Redis键
     * @param hKey Hash键
     * @param value 值
     */
    public void hSet(String key, String hKey, String value) {
        this.redisTemplate.opsForHash().put(key, hKey, value);
    }

    /**
     * 获取Hash中的数据
     *
     * @param key Redis键
     * @param hKey Hash键
     * @return Hash中的对象
     */
    public String hGet(String key, String hKey) {
        HashOperations<String, String, String> ops = this.redisTemplate.opsForHash();
        return ops.get(key, hKey);
    }

    /**
     * 获取多个Hash中的数据
     *
     * @param key Redis键
     * @param hKeys Hash键集合
     * @return Hash对象集合
     */
    public List<String> hMultiGet(String key, Collection<String> hKeys) {
        HashOperations<String, String, String> ops = this.redisTemplate.opsForHash();
        return ops.multiGet(key, hKeys);
    }

    /**
     * 删除Hash中的某条数据
     *
     * @param key Redis键
     * @param hKey Hash键
     * @return 是否成功
     */
    public Boolean hDelete(String key, String hKey) {
        return redisTemplate.opsForHash().delete(key, hKey) > 0;
    }

    /**
     * 获得缓存的基本对象列表
     *
     * @param pattern 字符串前缀
     * @return 对象列表
     */
    public Set<String> keys(String pattern) {
        return redisTemplate.keys(pattern);
    }

    /**
     * 向键值中设置增量
     * @param key 键名
     * @param delta 增量
     * @return 返回设置后的数值
     */
    public Long incr(String key, long delta) {
        return this.redisTemplate.opsForValue().increment(key, delta);
    }

    /**
     * 向键值中设置增量
     * @param key 键名
     * @param delta 增量
     * @return 返回设置后的数值
     */
    public Double incr(String key, Double delta) {
        return this.redisTemplate.opsForValue().increment(key, delta);
    }
}
