'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'

export default function RegisterPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [displayName, setDisplayName] = useState('')
  const [error, setError] = useState<string | null>(null)
  const router = useRouter()

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)

    const res = await fetch('/api/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password, displayName }),
    })

    if (!res.ok) {
      const data = await res.json()
      setError(data.error ?? 'Errore durante la registrazione')
      return
    }

    router.push('/login')
  }

  return (
    <form onSubmit={handleSubmit} style={{ maxWidth: 320, margin: '2rem auto', display: 'flex', flexDirection: 'column', gap: 8 }}>
      <h1>Registrati</h1>
      <input placeholder="Nome visualizzato" value={displayName} onChange={(e) => setDisplayName(e.target.value)} />
      <input placeholder="Email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
      <input placeholder="Password" type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
      {error && <p style={{ color: 'red' }}>{error}</p>}
      <button type="submit">Crea account</button>
    </form>
  )
}