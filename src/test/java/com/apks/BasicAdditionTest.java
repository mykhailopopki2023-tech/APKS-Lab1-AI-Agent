package com.apks;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class BasicAdditionTest {
    @Test
    void addsTwoIntegers() {
        Calculator calculator = new Calculator();

        assertEquals(7, calculator.add(3, 4));
    }
}
