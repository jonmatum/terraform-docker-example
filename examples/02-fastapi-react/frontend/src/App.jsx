import { useEffect, useState } from 'react'
import './App.css'

function App() {
  const [message, setMessage] = useState('Loading...')

  useEffect(() => {
    fetch('http://localhost:8000')
      .then(res => res.json())
      .then(data => setMessage(data.message))
      .catch(() => setMessage('Error fetching from backend'))
  }, [])

  return (
    <div className="App">
      <h1>React + Vite Frontend</h1>
      <p>{message}</p>
    </div>
  )
}

export default App
