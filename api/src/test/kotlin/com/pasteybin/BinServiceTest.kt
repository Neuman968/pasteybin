package com.pasteybin

import com.pasteybin.data.BinQueries
import com.pasteybin.service.BinService
import io.ktor.server.websocket.*
import io.mockk.clearMocks
import io.mockk.coEvery
import io.mockk.mockk
import kotlinx.coroutines.runBlocking
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.test.assertEquals

class BinServiceTest {

    val mockBinQueries: BinQueries = mockk()

    val mockWebSocketServerSession: DefaultWebSocketServerSession = mockk()

    lateinit var binService: BinService

    @BeforeTest
    fun setUp() {
        clearMocks(mockBinQueries, mockWebSocketServerSession)
        binService = BinService(mockBinQueries)
    }

//    @Test
//    fun testBinServiceConnect() {
//        coEvery { mockBinQueries.update(any(), any()) } returns Unit
//
//        runBlocking {
//            binService.connect("", mockWebSocketServerSession)
//        }
//        // Verify the method was called with the expected parameters or check return values here
//        // Use coVerify, assertEquals or any other testing method that you prefer
//    }
}