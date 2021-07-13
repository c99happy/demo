package com.example.demo;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.assertj.core.api.AssertionsForInterfaceTypes.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest
public class DemoApplicationTest {
    @Autowired
    private HelloService helloService;

    @Test
    public void contextLoads() {

        assertThat(helloService.test()).isEqualTo("hello");

    }

}
