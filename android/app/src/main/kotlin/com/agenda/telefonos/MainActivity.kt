package com.agenda.telefonos

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.agenda.telefonos.adapter.ContactAdapter
import com.agenda.telefonos.data.ContactRepository

class MainActivity : AppCompatActivity() {

    private lateinit var repository: ContactRepository
    private lateinit var adapter: ContactAdapter
    private lateinit var recyclerView: RecyclerView
    private lateinit var fabAdd: FloatingActionButton
    private lateinit var emptyStateView: View

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        repository = ContactRepository(this)
        
        recyclerView = findViewById(R.id.recyclerViewContacts)
        fabAdd = findViewById(R.id.fabAddContact)
        emptyStateView = findViewById(R.id.emptyStateView)

        setupRecyclerView()
        setupFAB()
        loadContacts()
    }

    private fun setupRecyclerView() {
        recyclerView.layoutManager = LinearLayoutManager(this)
        adapter = ContactAdapter(emptyList(), 
            onEditClick = { contact ->
                val intent = Intent(this, DetailActivity::class.java)
                intent.putExtra("contact_id", contact.id)
                intent.putExtra("contact_name", contact.name)
                intent.putExtra("contact_phone", contact.phone)
                intent.putExtra("contact_email", contact.email)
                startActivity(intent)
            },
            onDeleteClick = { contact ->
                deleteContact(contact.id)
            }
        )
        recyclerView.adapter = adapter
    }

    private fun setupFAB() {
        fabAdd.setOnClickListener {
            val intent = Intent(this, DetailActivity::class.java)
            startActivity(intent)
        }
    }

    private fun loadContacts() {
        val contacts = repository.getAllContacts()
        adapter.updateContacts(contacts)
        updateEmptyState(contacts.isEmpty())
    }

    private fun deleteContact(id: Int) {
        MaterialAlertDialogBuilder(this)
            .setTitle("Eliminar Contacto")
            .setMessage("¿Estás seguro de que deseas eliminar este contacto?")
            .setNegativeButton("Cancelar") { dialog, _ -> dialog.dismiss() }
            .setPositiveButton("Eliminar") { _, _ ->
                repository.deleteContact(id)
                loadContacts()
            }
            .show()
    }

    private fun updateEmptyState(isEmpty: Boolean) {
        if (isEmpty) {
            emptyStateView.visibility = View.VISIBLE
            recyclerView.visibility = View.GONE
        } else {
            emptyStateView.visibility = View.GONE
            recyclerView.visibility = View.VISIBLE
        }
    }

    override fun onResume() {
        super.onResume()
        loadContacts()
    }
}
