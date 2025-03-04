package com.niuma.common.utils;

import java.util.Base64;
import java.util.Base64.Decoder;
import java.util.Base64.Encoder;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;


public final class AesUtil {
    private AesUtil() {}

    // 加密
    public static String encrypt(String src) {
        return encrypt(src, "Lc1Zi8481lfH0F72", "OkxNe6vsRD1d3vUe");
    }

    public static String encrypt(String src, String key, String vec) {
        // 判断Key是否正确
        if (key == null)
            return null;
        // 判断Key是否为16位
        if (key.length() != 16)
            return null;
        byte[] encrypted = new byte[0];
        try {
            byte[] raw = key.getBytes(StandardCharsets.UTF_8);
            SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
            // "算法/模式/补码方式"
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            //使用CBC模式，需要一个向量iv，可增加加密算法的强度
            IvParameterSpec iv = new IvParameterSpec(vec.getBytes());
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec, iv);
            encrypted = cipher.doFinal(src.getBytes());
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 此处使用BASE64做转码功能，同时能起到2次加密的作用
        Encoder encoder = Base64.getEncoder();
        return encoder.encodeToString(encrypted);
    }

    // 解密
    public static String decrypt(String src) {
        if (StringUtils.isEmpty(src))
            return null;
        return decrypt(src, "Lc1Zi8481lfH0F72");
    }

    public static String decrypt(String src, String key) {
        if (StringUtils.isEmpty(src))
            return null;
        try {
            // 判断Key是否正确
            if (key == null)
                return null;
            // 判断Key是否为16位
            if (key.length() != 16)
                return null;
            byte[] raw = key.getBytes(StandardCharsets.UTF_8);
            SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            IvParameterSpec iv = new IvParameterSpec("OkxNe6vsRD1d3vUe".getBytes());
            cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);
            // 先用base64解密
            Decoder decoder = Base64.getDecoder();
            byte[] encrypted1 = decoder.decode(src);
            try {
                byte[] original = cipher.doFinal(encrypted1);
                String originalString = new String(original);
                return originalString;
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        String username = "test";
        String password = "test123";
        String ciphertext1 = encrypt(username);
        String ciphertext2 = encrypt(password);
        String plaintext1 = decrypt(ciphertext1);
        String plaintext2 = decrypt(ciphertext2);
        System.out.println("-----------------加密-----------");
        System.out.println("用户名明文：" + username);
        System.out.println("加密后：" + ciphertext1);
        System.out.println("密码明文：" + password);
        System.out.println("加密后：" + ciphertext2);
        System.out.println("-----------------解密-----------");
        System.out.println("用户名密文：" + ciphertext1);
        System.out.println("解密后：" + plaintext1);
        System.out.println("密码密文：" + ciphertext2);
        System.out.println("解密后：" + plaintext2);
    }
}
