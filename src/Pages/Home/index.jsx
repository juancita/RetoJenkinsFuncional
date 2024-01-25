import { useContext } from 'react'
import Card from '../../Components/Card'
import ProductDetail from '../../Components/ProductDetail'
import { ShoppingCartContext } from '../../Context'

function Home() {
  const context = useContext(ShoppingCartContext)

const renderView = () => {
  const filteredItems = context.filteredItems;

  if (filteredItems?.length > 0) {
    return (
      filteredItems?.map(item => (
        <Card key={item.id} data={item} />
      ))
    );
  } else {
    return (
      <div>We don't have anything :(</div>
    );
  }
}

  const renderView = () => {
  return (
    context.filteredItems?.length > 0
      ? renderCards(context.filteredItems)
      : <div>We don't have anything :(</div>
  );
}

const renderCards = (items) => {
  return items.map(item => (
    <Card key={item.id} data={item} />
  ));
}


  return (
    <div style={{ textAlign: 'center' }}> <center>
      <div className='flex items-center justify-center relative w-80 mb-4'>
        <h1 className='font-medium text-xl'>Exclusive Products</h1>
      </div>
      <input
        type="text"
        placeholder='Search a product'
        className='rounded-lg border border-black w-80 p-4 mb-4 focus:outline-none'
        onChange={(event) => context.setSearchByTitle(event.target.value)} />
      <div className='grid gap-4 grid-cols-4 w-full max-w-screen-lg'>
        {renderView()}
      </div>
      <ProductDetail />
      </center>
    </div>
  )
}

export default Home
