package com.agenda.telefonos.data

import android.content.Context
import com.agenda.telefonos.model.Contact

class ContactRepository(context: Context) {
    private val dbHelper = ContactDatabaseHelper(context)

    fun getAllContacts(): List<Contact> {
        val contacts = mutableListOf<Contact>()
        val db = dbHelper.readableDatabase
        val cursor = db.query(
            ContactDatabaseHelper.TABLE_CONTACTS,
            arrayOf(
                ContactDatabaseHelper.COLUMN_ID,
                ContactDatabaseHelper.COLUMN_NAME,
                ContactDatabaseHelper.COLUMN_PHONE,
                ContactDatabaseHelper.COLUMN_EMAIL
            ),
            null, null, null, null,
            "${ContactDatabaseHelper.COLUMN_NAME} ASC"
        )

        with(cursor) {
            while (moveToNext()) {
                val contact = Contact(
                    id = getInt(getColumnIndexOrThrow(ContactDatabaseHelper.COLUMN_ID)),
                    name = getString(getColumnIndexOrThrow(ContactDatabaseHelper.COLUMN_NAME)),
                    phone = getString(getColumnIndexOrThrow(ContactDatabaseHelper.COLUMN_PHONE)),
                    email = getString(getColumnIndexOrThrow(ContactDatabaseHelper.COLUMN_EMAIL))
                )
                contacts.add(contact)
            }
            close()
        }
        return contacts
    }

    fun addContact(contact: Contact): Long {
        val db = dbHelper.writableDatabase
        val values = android.content.ContentValues().apply {
            put(ContactDatabaseHelper.COLUMN_NAME, contact.name)
            put(ContactDatabaseHelper.COLUMN_PHONE, contact.phone)
            put(ContactDatabaseHelper.COLUMN_EMAIL, contact.email)
        }
        return db.insert(ContactDatabaseHelper.TABLE_CONTACTS, null, values)
    }

    fun updateContact(contact: Contact): Int {
        val db = dbHelper.writableDatabase
        val values = android.content.ContentValues().apply {
            put(ContactDatabaseHelper.COLUMN_NAME, contact.name)
            put(ContactDatabaseHelper.COLUMN_PHONE, contact.phone)
            put(ContactDatabaseHelper.COLUMN_EMAIL, contact.email)
        }
        return db.update(
            ContactDatabaseHelper.TABLE_CONTACTS,
            values,
            "${ContactDatabaseHelper.COLUMN_ID} = ?",
            arrayOf(contact.id.toString())
        )
    }

    fun deleteContact(id: Int): Int {
        val db = dbHelper.writableDatabase
        return db.delete(
            ContactDatabaseHelper.TABLE_CONTACTS,
            "${ContactDatabaseHelper.COLUMN_ID} = ?",
            arrayOf(id.toString())
        )
    }

    fun getContactById(id: Int): Contact? {
        val db = dbHelper.readableDatabase
        val cursor = db.query(
            ContactDatabaseHelper.TABLE_CONTACTS,
            arrayOf(
                ContactDatabaseHelper.COLUMN_ID,
                ContactDatabaseHelper.COLUMN_NAME,
                ContactDatabaseHelper.COLUMN_PHONE,
                ContactDatabaseHelper.COLUMN_EMAIL
            ),
            "${ContactDatabaseHelper.COLUMN_ID} = ?",
            arrayOf(id.toString()),
            null, null, null
        )

        return if (cursor.moveToFirst()) {
            val contact = Contact(
                id = cursor.getInt(cursor.getColumnIndexOrThrow(ContactDatabaseHelper.COLUMN_ID)),
                name = cursor.getString(cursor.getColumnIndexOrThrow(ContactDatabaseHelper.COLUMN_NAME)),
                phone = cursor.getString(cursor.getColumnIndexOrThrow(ContactDatabaseHelper.COLUMN_PHONE)),
                email = cursor.getString(cursor.getColumnIndexOrThrow(ContactDatabaseHelper.COLUMN_EMAIL))
            )
            cursor.close()
            contact
        } else {
            cursor.close()
            null
        }
    }
}
