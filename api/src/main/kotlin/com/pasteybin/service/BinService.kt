package com.pasteybin.service

import com.pasteybin.data.Bin
import com.pasteybin.data.BinQueries
import java.time.Instant

val binIdChars: List<Char> = ('A'..'Z') + ('a'..'z') + ('0'..'9')

class BinService(private val binQueries: BinQueries) {

    fun getOrderLastUpdated(): List<Bin> = binQueries.selectAll().executeAsList()

    fun updateContent(binId: String, content: String) = binQueries.update(content, Instant.now(), binId)

    fun newBin(binId: String = generateBinId()): Bin = Bin(
        id = binId,
        content = "",
        createdTime = Instant.now(),
        lastUpdated = Instant.now(),
    ).apply { binQueries.insert(this) }

    private fun generateBinId(): String = (1..3)
        .map { binIdChars.random() }
        .joinToString("")
}