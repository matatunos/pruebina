package com.agenda.telefonos.model

data class Contact(
    val id: Int = 0,
    val name: String,
    val phone: String,
    val email: String = ""
)
