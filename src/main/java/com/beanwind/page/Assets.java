package com.beanwind.page;

import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Versioned URLs for static files, e.g. {@code /css/output.css?v=1a2b3c4d}. The version is a hash of the file's
 * content, so after a deploy browsers fetch a changed file instead of reusing an old cached copy, while unchanged
 * files stay cached. Used by layout/page.jte: {@code ${Assets.url("/css/output.css")}}.
 */
public final class Assets {

    private static final Map<String, String> URLS = new ConcurrentHashMap<>();

    private Assets() {
    }

    /** {@code path} is the public path of a file in src/main/resources/static, e.g. "/js/about.js". */
    public static String url(String path) {
        return URLS.computeIfAbsent(path, Assets::versioned);
    }

    private static String versioned(String path) {
        try (InputStream in = Assets.class.getResourceAsStream("/static" + path)) {
            if (in == null) {
                return path;
            }
            byte[] hash = MessageDigest.getInstance("SHA-256").digest(in.readAllBytes());
            return path + "?v=" + HexFormat.of().formatHex(hash, 0, 4);
        } catch (IOException | NoSuchAlgorithmException e) {
            return path; // unversioned still works, it just may be cached longer
        }
    }
}
