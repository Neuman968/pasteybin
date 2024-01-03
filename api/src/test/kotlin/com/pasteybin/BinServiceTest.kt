package com.pasteybin

import app.cash.sqldelight.driver.jdbc.sqlite.JdbcSqliteDriver
import com.pasteybin.data.Bin
import com.pasteybin.data.BinQueries
import com.pasteybin.data.Database
import com.pasteybin.plugins.instantAdapter
import com.pasteybin.service.BinService
import io.ktor.server.websocket.*
import io.ktor.websocket.*
import io.mockk.*
import kotlinx.coroutines.async
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.delay
import kotlinx.coroutines.runBlocking
import java.time.Instant
import java.util.concurrent.ConcurrentHashMap
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.time.Duration.Companion.milliseconds
import kotlin.time.Duration.Companion.seconds

class BinServiceTest {

    val mockWebSocketServerSession: DefaultWebSocketServerSession = mockk(relaxed = true)

    val mockWebSocketServerSession2: DefaultWebSocketServerSession = mockk(relaxed = true)

    val connectionMap: MutableMap<String, MutableSet<DefaultWebSocketServerSession>> = ConcurrentHashMap()

    lateinit var binService: BinService

    lateinit var binQueries: BinQueries

    val testCreatedTime = Instant.now()

    val testBin = Bin(
        id = "abc",
        content = "This is some test content",
        title = "test title",
        createdTime = testCreatedTime.minusSeconds(60 * 60),
        lastUpdatedTime = testCreatedTime.minusSeconds(60 * 60),
    )

    val testBin2 = Bin(
        id = "123",
        content = "test 123",
        title = "test title",
        createdTime = testCreatedTime,
        lastUpdatedTime = testCreatedTime,
    )

    val testBin3 = Bin(
        id = "000",
        content = "Foobar",
        title = "test title",
        createdTime = testCreatedTime.minusSeconds(60 * 60),
        lastUpdatedTime = testCreatedTime.minusSeconds(60 * 10),
    )

    @BeforeTest
    fun setUp() {
        clearMocks(mockWebSocketServerSession, mockWebSocketServerSession2)
        binQueries = Database(
            JdbcSqliteDriver(JdbcSqliteDriver.IN_MEMORY).apply {
                Database.Schema.create(this)
            },
            Bin.Adapter(instantAdapter, instantAdapter)
        ).binQueries
        binQueries.insert(testBin)
        binQueries.insert(testBin2)
        binQueries.insert(testBin3)

        binService = BinService(binQueries, connectionMap)
    }

    @Test
    fun `test connect passing session expecting bin content sent over session`() {
        runBlocking {
            binService.connect("abc", mockWebSocketServerSession)
        }
        coVerify(exactly = 1) {
            mockWebSocketServerSession.send(match {
                String(it.data) == testBin.content
            })
        }
    }

    @Test
    fun `test connect passing session expecting connection added to map`() {
        val testChannel = Channel<Frame> {
            while (true) {
                runBlocking {
                    delay(10.milliseconds)
                }
            }
        }
        every { mockWebSocketServerSession.incoming } returns testChannel

        runBlocking {
            val connection = async { binService.connect("abc", mockWebSocketServerSession) }
            delay(20.milliseconds)
            assert(connectionMap["abc"]?.contains(mockWebSocketServerSession) == true) {
                "Did not contain mock web socket server session"
            }
            testChannel.cancel()
            connection.cancel()
        }
    }

    @Test
    fun `test get order last updated expecting bins returned in order`() {
        val result = binService.getOrderLastUpdated()

        assert(result.size == 3) {
            "Size should have been 3"
        }
        assert(result[0].id == testBin2.id) { "id: 123 should have been first" }
        assert(result[1].id == testBin3.id) { "id: 000 should have been second" }
        assert(result[2].id == testBin.id) { "id: abc should have been third" }
    }

    @Test
    fun `test new bin expecting new bin inserted`() {
        val bin = binService.newBin()

        assert(bin.content == "") { "Content was not blank" }
        assert(binQueries.selectAll().executeAsList().any { it.id == bin.id }) {
            "Did not contain new bin"
        }

        assert(binService.getOrderLastUpdated().first().id == bin.id) {
            "New bin should have been last updated"
        }
    }

    @Test
    fun `test update bin passing updated bin title expecting title updated`() {
        val updatedBin = binService.updateTitle("abc", "New Title!!")
        val savedBin = binQueries.selectOne("abc").executeAsOneOrNull()
        assert(savedBin?.title == "New Title!!") { "Title was not updated" }
        assert(savedBin?.id == updatedBin?.id) { "Returned bin was not as expected" }
        assert(savedBin?.title == updatedBin?.title) { "Returned bin title was not as expected" }
    }
}