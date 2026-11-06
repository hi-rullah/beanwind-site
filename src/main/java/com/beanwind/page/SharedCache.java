package com.beanwind.page;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Marks a page handler whose anonymous version may be stored by a shared cache such as a CDN, see
 * {@link SharedCacheInterceptor}. Only for pages that look the same for every signed-out visitor.
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface SharedCache {
}
