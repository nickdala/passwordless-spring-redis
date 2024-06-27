package com.nickthecloudguy.redis.passwordless;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;


@RestController
public class WebController {

    @GetMapping("/{name}")
    @Cacheable("azureCache")
    public String getMethodName(@PathVariable("name") String name) {
        return "Hello " + name;
    }
}
