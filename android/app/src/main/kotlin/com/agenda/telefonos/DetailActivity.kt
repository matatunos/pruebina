package com.agenda.telefonos

import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.agenda.telefonos.data.ContactRepository
import com.agenda.telefonos.model.Contact

class DetailActivity : AppCompatActivity() {

    private lateinit var repository: ContactRepository
    private lateinit var editName: EditText
    private lateinit var editPhone: EditText
    private lateinit var editEmail: EditText
    private lateinit var btnSave: Button
    private lateinit var btnDelete: Button
    private lateinit var btnCancel: Button
    
    private var contactId: Int = -1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_detail)

        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        repository = ContactRepository(this)

        editName = findViewById(R.id.editName)
        editPhone = findViewById(R.id.editPhone)
        editEmail = findViewById(R.id.editEmail)
        btnSave = findViewById(R.id.btnSave)
        btnDelete = findViewById(R.id.btnDelete)
        btnCancel = findViewById(R.id.btnCancel)

        contactId = intent.getIntExtra("contact_id", -1)

        if (contactId != -1) {
            loadContact(contactId)
            supportActionBar?.title = "Editar Contacto"
            btnDelete.visibility = View.VISIBLE
        } else {
            supportActionBar?.title = "Nuevo Contacto"
            btnDelete.visibility = View.GONE
        }

        btnSave.setOnClickListener { saveContact() }
        btnDelete.setOnClickListener { deleteContact() }
        btnCancel.setOnClickListener { finish() }
    }

    private fun loadContact(id: Int) {
        val contact = repository.getContactById(id)
        contact?.let {
            editName.setText(it.name)
            editPhone.setText(it.phone)
            editEmail.setText(it.email)
        }
    }

    private fun saveContact() {
        val name = editName.text.toString().trim()
        val phone = editPhone.text.toString().trim()
        val email = editEmail.text.toString().trim()

        if (name.isEmpty() || phone.isEmpty()) {
            Toast.makeText(this, "El nombre y teléfono son requeridos", Toast.LENGTH_SHORT).show()
            return
        }

        val contact = Contact(
            id = contactId,
            name = name,
            phone = phone,
            email = email
        )

        if (contactId == -1) {
            repository.addContact(contact)
            Toast.makeText(this, "Contacto agregado exitosamente", Toast.LENGTH_SHORT).show()
        } else {
            repository.updateContact(contact)
            Toast.makeText(this, "Contacto actualizado exitosamente", Toast.LENGTH_SHORT).show()
        }

        finish()
    }

    private fun deleteContact() {
        if (contactId != -1) {
            repository.deleteContact(contactId)
            Toast.makeText(this, "Contacto eliminado", Toast.LENGTH_SHORT).show()
            finish()
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        finish()
        return true
    }
}
