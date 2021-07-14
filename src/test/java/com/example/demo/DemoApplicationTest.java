package com.example.demo;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;
@SpringBootTest
public class DemoApplicationTest {
    @Autowired
    private HelloService helloService;

    @Test
    public void contextLoads() {
        assertEquals(helloService.test(), "hello2");

    }

}
